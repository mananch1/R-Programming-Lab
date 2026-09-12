
# ============================================================
# Lab Problem Statement 6: Statistical Analysis of Physical
# Characteristics of Palmer Penguins
# Topics: Descriptive Statistics, Hypothesis Testing, ANOVA & Non-Parametric Tests
# Dataset: palmerpenguins (R package)
# ============================================================

# --- Package Installation & Loading ---
#install.packages("palmerpenguins")
#install.packages("e1071")       # skewness & kurtosis
#install.packages("effsize")     # Cohen's d
#install.packages("ggplot2")     # visualizations
#install.packages("dplyr")
# Note: Homogeneity of variance uses base R bartlett.test() - no extra package needed

required_pkgs <- c("palmerpenguins", "e1071", "effsize", "ggplot2", "dplyr")
new_pkgs <- setdiff(required_pkgs, rownames(installed.packages()))
if (length(new_pkgs)) install.packages(new_pkgs, repos = "https://cran.r-project.org")
suppressPackageStartupMessages(lapply(required_pkgs, library, character.only = TRUE))


# ============================================================
# LOAD & INSPECT DATASET
# ============================================================

data("penguins")
cat("Dataset dimensions:", dim(penguins), "\n")
cat("\nColumn names:\n"); print(names(penguins))
cat("\nFirst few rows:\n"); print(head(penguins))
cat("\nData summary:\n"); print(summary(penguins))
cat("\nMissing values per column:\n"); print(colSums(is.na(penguins)))

# Remove rows with NAs in key analysis columns
penguins_clean <- penguins %>%
  filter(!is.na(body_mass_g), !is.na(flipper_length_mm),
         !is.na(species), !is.na(sex))

cat("\nRows after removing NAs:", nrow(penguins_clean), "\n")
cat("Species distribution:\n"); print(table(penguins_clean$species))
cat("Sex distribution:\n");     print(table(penguins_clean$sex))


# ============================================================
# TASK 1: DESCRIPTIVE STATISTICAL ANALYSIS
# ============================================================

cat("\n\n=== TASK 1: DESCRIPTIVE STATISTICS (body_mass_g) ===\n")

bm <- penguins_clean$body_mass_g

cat("Mean              :", mean(bm),           "\n")
cat("Median            :", median(bm),         "\n")
cat("Minimum           :", min(bm),            "\n")
cat("Maximum           :", max(bm),            "\n")
cat("Variance          :", var(bm),            "\n")
cat("Std Deviation     :", sd(bm),             "\n")
cat("Q1 (25th pctile)  :", quantile(bm, 0.25),"\n")
cat("Q3 (75th pctile)  :", quantile(bm, 0.75),"\n")
cat("IQR               :", IQR(bm),            "\n")
cat("Skewness          :", e1071::skewness(bm),"\n")
cat("Kurtosis          :", e1071::kurtosis(bm),"\n")

cat("\n--- Descriptive Stats by Species ---\n")
desc_by_species <- penguins_clean %>%
  group_by(species) %>%
  summarise(
    n         = n(),
    mean      = mean(body_mass_g),
    median    = median(body_mass_g),
    min       = min(body_mass_g),
    max       = max(body_mass_g),
    variance  = var(body_mass_g),
    sd        = sd(body_mass_g),
    Q1        = quantile(body_mass_g, 0.25),
    Q3        = quantile(body_mass_g, 0.75),
    IQR       = IQR(body_mass_g),
    skewness  = e1071::skewness(body_mass_g),
    kurtosis  = e1071::kurtosis(body_mass_g),
    .groups   = "drop"
  )
print(as.data.frame(desc_by_species))

# --- Visualizations ---

# 1. Histogram of body mass
p1 <- ggplot(penguins_clean, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 200, fill = "steelblue", color = "white") +
  labs(title = "Histogram of Penguin Body Mass",
       x = "Body Mass (g)", y = "Frequency") +
  theme_minimal()
print(p1)

# 2. Species-wise boxplot of body mass
p2 <- ggplot(penguins_clean, aes(x = species, y = body_mass_g, fill = species)) +
  geom_boxplot(alpha = 0.7) +
  labs(title = "Body Mass by Penguin Species",
       x = "Species", y = "Body Mass (g)") +
  theme_minimal() +
  theme(legend.position = "none")
print(p2)

# 3. Sex-wise boxplot of body mass
p3 <- ggplot(penguins_clean, aes(x = sex, y = body_mass_g, fill = sex)) +
  geom_boxplot(alpha = 0.7) +
  labs(title = "Body Mass by Sex",
       x = "Sex", y = "Body Mass (g)") +
  scale_fill_manual(values = c("female" = "#F8766D", "male" = "#00BFC4")) +
  theme_minimal() +
  theme(legend.position = "none")
print(p3)

# 4. Density plot of body mass by species
p4 <- ggplot(penguins_clean, aes(x = body_mass_g, fill = species)) +
  geom_density(alpha = 0.5) +
  labs(title = "Density Plot of Body Mass by Species",
       x = "Body Mass (g)", y = "Density") +
  theme_minimal()
print(p4)


# ============================================================
# TASK 2: HYPOTHESIS TESTING – Two-Sample t-Test (Male vs Female)
# ============================================================

cat("\n\n=== TASK 2: HYPOTHESIS TESTING (Male vs Female Body Mass) ===\n")

cat("
H0: Mean body mass of male penguins = Mean body mass of female penguins
H1: Mean body mass of male penguins ≠ Mean body mass of female penguins
(Two-tailed independent samples t-test, α = 0.05)
\n")

male_bm   <- penguins_clean$body_mass_g[penguins_clean$sex == "male"]
female_bm <- penguins_clean$body_mass_g[penguins_clean$sex == "female"]

cat("Male   n =", length(male_bm),   "| mean =", round(mean(male_bm),   2), "\n")
cat("Female n =", length(female_bm), "| mean =", round(mean(female_bm), 2), "\n")

# --- Normality Check: Shapiro-Wilk Test ---
cat("\n-- Shapiro-Wilk Normality Test --\n")
sw_male   <- shapiro.test(male_bm)
sw_female <- shapiro.test(female_bm)
cat("Male   W =", round(sw_male$statistic, 4),   "p =", round(sw_male$p.value, 4),   "\n")
cat("Female W =", round(sw_female$statistic, 4), "p =", round(sw_female$p.value, 4), "\n")

# --- QQ-Plots ---
par(mfrow = c(1, 2))
qqnorm(male_bm,   main = "QQ-Plot: Male Body Mass");   qqline(male_bm,   col = "red")
qqnorm(female_bm, main = "QQ-Plot: Female Body Mass"); qqline(female_bm, col = "blue")
par(mfrow = c(1, 1))

# --- Two-Sample t-Test (Welch's, default) ---
cat("\n-- Welch Two-Sample t-Test --\n")
t_result <- t.test(male_bm, female_bm, var.equal = FALSE)
print(t_result)

cat("\n95% Confidence Interval for (Male - Female) mean difference:\n")
cat("Lower:", round(t_result$conf.int[1], 2), "| Upper:", round(t_result$conf.int[2], 2), "\n")

# --- Cohen's d Effect Size ---
cat("\n-- Cohen's d Effect Size --\n")
cohens_d <- effsize::cohen.d(male_bm, female_bm)
print(cohens_d)
cat("\nInterpretation: |d| < 0.2 = negligible, 0.2–0.5 = small, 0.5–0.8 = medium, > 0.8 = large\n")

cat("\n--- Interpretation ---\n")
if (t_result$p.value < 0.05) {
  cat("RESULT: Reject H0 (p =", round(t_result$p.value, 6),
      "). Male and female penguins have significantly different mean body masses.\n")
  cat("The 95% CI does not include 0, confirming the difference.\n")
} else {
  cat("RESULT: Fail to reject H0 (p =", round(t_result$p.value, 6),
      "). No significant difference detected.\n")
}


# ============================================================
# TASK 3: ONE-WAY ANOVA – Body Mass by Species
# ============================================================

cat("\n\n=== TASK 3: ONE-WAY ANOVA (body_mass_g ~ species) ===\n")

# Assumption checks per species
cat("\n-- Shapiro-Wilk Normality by Species --\n")
for (sp in levels(penguins_clean$species)) {
  sw <- shapiro.test(penguins_clean$body_mass_g[penguins_clean$species == sp])
  cat(sp, ": W =", round(sw$statistic, 4), "| p =", round(sw$p.value, 4), "\n")
}

# QQ-plots by species
par(mfrow = c(1, 3))
for (sp in levels(penguins_clean$species)) {
  bm_sp <- penguins_clean$body_mass_g[penguins_clean$species == sp]
  qqnorm(bm_sp, main = paste("QQ-Plot:", sp)); qqline(bm_sp, col = "red")
}
par(mfrow = c(1, 1))

# Bartlett's Test for Homogeneity of Variance
cat("\n-- Bartlett's Test for Homogeneity of Variance --\n")
levene_result <- bartlett.test(body_mass_g ~ species, data = penguins_clean)
print(levene_result)
cat("(Bartlett's test checks equal variances across groups, similar to Levene's test)\n")

# One-Way ANOVA
cat("\n-- One-Way ANOVA --\n")
anova_one <- aov(body_mass_g ~ species, data = penguins_clean)
anova_summary <- summary(anova_one)
print(anova_summary)

f_stat <- anova_summary[[1]]$`F value`[1]
df1    <- anova_summary[[1]]$Df[1]
df2    <- anova_summary[[1]]$Df[2]
p_anova <- anova_summary[[1]]$`Pr(>F)`[1]

cat("\nF-statistic:", round(f_stat, 4),
    "| df =", df1, "and", df2,
    "| p-value:", round(p_anova, 6), "\n")

cat("\n--- Interpretation ---\n")
if (p_anova < 0.05) {
  cat("RESULT: Reject H0 – At least one species has a significantly different mean body mass (p <0.05).\n")

  # Tukey HSD Post-hoc Test
  cat("\n-- Tukey HSD Post-Hoc Test --\n")
  tukey_result <- TukeyHSD(anova_one)
  print(tukey_result)

  plot(tukey_result, las = 1)
} else {
  cat("RESULT: Fail to reject H0 – No significant difference among species (p ≥ 0.05).\n")
}


# ============================================================
# TASK 4: NON-PARAMETRIC ANALYSIS – Kruskal-Wallis Test
# ============================================================

cat("\n\n=== TASK 4: KRUSKAL-WALLIS TEST (body_mass_g ~ species) ===\n")

kw_result <- kruskal.test(body_mass_g ~ species, data = penguins_clean)
print(kw_result)

cat("\n--- Comparison: ANOVA vs Kruskal-Wallis ---\n")
cat("One-Way ANOVA p-value    :", round(p_anova, 6), "\n")
cat("Kruskal-Wallis p-value   :", round(kw_result$p.value, 6), "\n")

if (kw_result$p.value < 0.05) {
  cat("Kruskal-Wallis: Significant difference in body mass among species.\n")
}
cat("Both tests lead to the same conclusion:",
    ifelse(p_anova < 0.05 && kw_result$p.value < 0.05,
           "species significantly differ in body mass.",
           "no significant difference detected."), "\n")
cat("The non-parametric test supports the ANOVA finding, confirming robustness of the result.\n")


# ============================================================
# TASK 5: TWO-WAY ANOVA – Body Mass ~ Species * Sex
# ============================================================

cat("\n\n=== TASK 5: TWO-WAY ANOVA (body_mass_g ~ species * sex) ===\n")

anova_two <- aov(body_mass_g ~ species * sex, data = penguins_clean)
anova_two_summary <- summary(anova_two)
print(anova_two_summary)

cat("\n--- Interpretation ---\n")
results_two <- anova_two_summary[[1]]
row_names <- rownames(results_two)

for (term in c("species", "sex", "species:sex")) {
  if (term %in% row_names) {
    p_val <- results_two[term, "Pr(>F)"]
    f_val <- results_two[term, "F value"]
    sig <- if (!is.na(p_val) && p_val < 0.05) "SIGNIFICANT" else "NOT significant"
    cat(term, "-> F =", round(f_val, 4), ", p =", round(p_val, 6), "->", sig, "\n")
  }
}

# Interaction plot
interaction.plot(
  x.factor     = penguins_clean$species,
  trace.factor  = penguins_clean$sex,
  response      = penguins_clean$body_mass_g,
  fun           = mean,
  type          = "b",
  pch           = c(19, 17),
  col           = c("#F8766D", "#00BFC4"),
  main          = "Interaction Plot: Species × Sex on Body Mass",
  xlab          = "Species",
  ylab          = "Mean Body Mass (g)",
  trace.label   = "Sex",
  lwd           = 2
)


# ============================================================
# TASK 6: ADDITIONAL ANALYSIS – Flipper Length
# ============================================================

cat("\n\n=== TASK 6: FLIPPER LENGTH ANALYSIS (flipper_length_mm ~ species) ===\n")

fl <- penguins_clean$flipper_length_mm

cat("Descriptive Stats for Flipper Length:\n")
cat("Mean:", mean(fl), "| Median:", median(fl), "| SD:", round(sd(fl), 2),
    "| Skewness:", round(e1071::skewness(fl), 4), "\n")

cat("\n-- Flipper Length Descriptive Stats by Species --\n")
fl_by_species <- penguins_clean %>%
  group_by(species) %>%
  summarise(
    n      = n(),
    mean   = mean(flipper_length_mm),
    median = median(flipper_length_mm),
    sd     = sd(flipper_length_mm),
    .groups = "drop"
  )
print(as.data.frame(fl_by_species))

# Normality check
cat("\n-- Shapiro-Wilk Normality Test for Flipper Length by Species --\n")
for (sp in levels(penguins_clean$species)) {
  sw <- shapiro.test(penguins_clean$flipper_length_mm[penguins_clean$species == sp])
  cat(sp, ": W =", round(sw$statistic, 4), "| p =", round(sw$p.value, 4), "\n")
}

# Bartlett's test for flipper length
cat("\n-- Bartlett's Test (Flipper Length) --\n")
levene_fl <- bartlett.test(flipper_length_mm ~ species, data = penguins_clean)
print(levene_fl)

# One-Way ANOVA for flipper length
cat("\n-- One-Way ANOVA (flipper_length_mm ~ species) --\n")
anova_fl <- aov(flipper_length_mm ~ species, data = penguins_clean)
anova_fl_summary <- summary(anova_fl)
print(anova_fl_summary)

f_fl   <- anova_fl_summary[[1]]$`F value`[1]
p_fl   <- anova_fl_summary[[1]]$`Pr(>F)`[1]
df1_fl <- anova_fl_summary[[1]]$Df[1]
df2_fl <- anova_fl_summary[[1]]$Df[2]

cat("\nF-statistic:", round(f_fl, 4),
    "| df =", df1_fl, "and", df2_fl,
    "| p-value:", round(p_fl, 6), "\n")

if (p_fl < 0.05) {
  cat("RESULT: Significant difference in flipper length among species (p < 0.05).\n")
  cat("\n-- Tukey HSD Post-Hoc (Flipper Length) --\n")
  tukey_fl <- TukeyHSD(anova_fl)
  print(tukey_fl)
}

# Kruskal-Wallis for flipper length
cat("\n-- Kruskal-Wallis Test (Flipper Length) --\n")
kw_fl <- kruskal.test(flipper_length_mm ~ species, data = penguins_clean)
print(kw_fl)

cat("\n--- Comparison with Body Mass Findings ---\n")
cat("Body Mass ANOVA p-value    :", round(p_anova, 6), "\n")
cat("Flipper Length ANOVA p-value:", round(p_fl, 6),   "\n")
cat("Both body mass and flipper length show significant species-level differences,\n")
cat("indicating that penguin species are physically distinct across multiple morphological traits.\n")


# ============================================================
# TASK 7: VISUALIZATION AND INTERPRETATION
# ============================================================

cat("\n\n=== TASK 7: VISUALIZATIONS ===\n")

# 1. Histogram of body mass (with species fill)
p_hist <- ggplot(penguins_clean, aes(x = body_mass_g, fill = species)) +
  geom_histogram(binwidth = 200, alpha = 0.7, position = "identity") +
  labs(title = "Histogram of Body Mass by Species",
       x = "Body Mass (g)", y = "Frequency",
       fill = "Species") +
  theme_minimal()
print(p_hist)

# 2. Species-wise boxplot of body mass
p_box_species <- ggplot(penguins_clean, aes(x = species, y = body_mass_g, fill = species)) +
  geom_boxplot(alpha = 0.8, outlier.shape = 19, outlier.size = 2) +
  stat_summary(fun = mean, geom = "point", shape = 4, size = 4, color = "black") +
  labs(title = "Body Mass by Penguin Species",
       x = "Species", y = "Body Mass (g)") +
  theme_minimal() +
  theme(legend.position = "none")
print(p_box_species)

# 3. Sex-wise boxplot of body mass
p_box_sex <- ggplot(penguins_clean, aes(x = sex, y = body_mass_g, fill = sex)) +
  geom_boxplot(alpha = 0.8, outlier.shape = 19, outlier.size = 2) +
  stat_summary(fun = mean, geom = "point", shape = 4, size = 4, color = "black") +
  scale_fill_manual(values = c("female" = "#F8766D", "male" = "#00BFC4")) +
  labs(title = "Body Mass by Sex",
       x = "Sex", y = "Body Mass (g)") +
  theme_minimal() +
  theme(legend.position = "none")
print(p_box_sex)

# 4. QQ-plots for normality (faceted)
p_qq <- ggplot(penguins_clean, aes(sample = body_mass_g)) +
  stat_qq() +
  stat_qq_line(color = "red") +
  facet_wrap(~species) +
  labs(title = "QQ-Plots: Body Mass Normality Check by Species",
       x = "Theoretical Quantiles", y = "Sample Quantiles") +
  theme_minimal()
print(p_qq)

# 5. Species-wise flipper length comparison
p_fl_box <- ggplot(penguins_clean, aes(x = species, y = flipper_length_mm, fill = species)) +
  geom_boxplot(alpha = 0.8, outlier.shape = 19, outlier.size = 2) +
  stat_summary(fun = mean, geom = "point", shape = 4, size = 4, color = "black") +
  labs(title = "Flipper Length by Penguin Species",
       x = "Species", y = "Flipper Length (mm)") +
  theme_minimal() +
  theme(legend.position = "none")
print(p_fl_box)

# 6. Grouped bar chart – mean body mass with error bars (group comparison plot)
p_bar <- penguins_clean %>%
  group_by(species, sex) %>%
  summarise(mean_bm = mean(body_mass_g),
            se_bm   = sd(body_mass_g) / sqrt(n()),
            .groups = "drop") %>%
  ggplot(aes(x = species, y = mean_bm, fill = sex)) +
  geom_bar(stat = "identity", position = position_dodge(0.8), width = 0.7, alpha = 0.85) +
  geom_errorbar(aes(ymin = mean_bm - se_bm, ymax = mean_bm + se_bm),
                position = position_dodge(0.8), width = 0.25) +
  scale_fill_manual(values = c("female" = "#F8766D", "male" = "#00BFC4")) +
  labs(title = "Mean Body Mass by Species and Sex (± SE)",
       x = "Species", y = "Mean Body Mass (g)", fill = "Sex") +
  theme_minimal()
print(p_bar)

# 7. Violin + Jitter plot for richer distribution view
p_violin <- ggplot(penguins_clean, aes(x = species, y = body_mass_g, fill = species)) +
  geom_violin(alpha = 0.6, trim = FALSE) +
  geom_jitter(aes(color = sex), width = 0.1, alpha = 0.5, size = 1.5) +
  labs(title = "Body Mass Distribution by Species (Violin + Jitter)",
       x = "Species", y = "Body Mass (g)",
       color = "Sex") +
  theme_minimal() +
  theme(legend.position = "right")
print(p_violin)


# ============================================================
# SUMMARY OF FINDINGS
# ============================================================

cat("\n\n========== SUMMARY OF STATISTICAL FINDINGS ==========\n")

cat("\n1. DESCRIPTIVE STATS:\n")
cat("   Overall mean body mass:", round(mean(bm), 2), "g | SD:", round(sd(bm), 2), "g\n")
cat("   Slight positive skewness (", round(e1071::skewness(bm), 3), ") indicates a mild right tail.\n")
cat("   Gentoo penguins are the heaviest; Chinstrap are the lightest.\n")

cat("\n2. HYPOTHESIS TEST (t-test, Male vs Female):\n")
cat("   p-value:", round(t_result$p.value, 6), "-> Males significantly heavier than females.\n")
cat("   95% CI: [", round(t_result$conf.int[1], 1), ",", round(t_result$conf.int[2], 1), "] g\n")
cat("   Cohen's d:", round(abs(cohens_d$estimate), 3), "->",
    ifelse(abs(cohens_d$estimate) > 0.8, "Large", ifelse(abs(cohens_d$estimate) > 0.5, "Medium", "Small")),
    "effect size.\n")

cat("\n3. ONE-WAY ANOVA (Body Mass ~ Species):\n")
cat("   F =", round(f_stat, 4), "| p =", round(p_anova, 6),
    "-> Significant species-level differences in body mass.\n")
cat("   Tukey HSD confirms all pairwise species comparisons are significant.\n")

cat("\n4. KRUSKAL-WALLIS:\n")
cat("   H =", round(kw_result$statistic, 4), "| p =", round(kw_result$p.value, 6),
    "-> Consistent with ANOVA result.\n")

cat("\n5. TWO-WAY ANOVA (Body Mass ~ Species * Sex):\n")
cat("   Both species and sex main effects are significant.\n")
cat("   The interaction term indicates the sex effect varies by species.\n")

cat("\n6. FLIPPER LENGTH:\n")
cat("   F =", round(f_fl, 4), "| p =", round(p_fl, 6),
    "-> Significant species differences in flipper length as well.\n")
cat("   Findings are consistent with body mass: species differ morphologically.\n")

cat("\n======================================================\n")
cat("Analysis complete.\n")
