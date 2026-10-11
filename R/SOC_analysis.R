# ============================================================
# SOC meta analysis: manure and other organic amendments (v1.0.1: t based CI uses study level df)
# Run from the repo root folder (the one that contains data/ and R/)
# Needs: metafor  (install.packages("metafor"))
# ============================================================
library(metafor)
dir.create("results", showWarnings = FALSE)

# ---- STEP 1: IMPORT AND CHECKS ----
dat <- read.csv("data/SOC_extraction_final.csv", stringsAsFactors = FALSE)
dim(dat)                                   # 20 rows
table(dat$control_type)                    # unamended vs fert_only
table(dat$var_type)                        # SD, SE, unclear
tapply(dat$study_id, dat$control_type, function(x) length(unique(x)))
colSums(is.na(dat[, c("mean_c","mean_t","var_c","var_t","n_c","n_t")]))
min(dat$mean_c)                            # must be above 0

# ---- STEP 2: SD CONVERSION AND lnRR ----
make_es <- function(d, unclear_as = "SD") {
  # 'unclear' rows are treated as SD (main run) or SE (sensitivity)
  vt <- ifelse(d$var_type == "unclear", unclear_as, d$var_type)
  # SE to SD: SD = SE * sqrt(n)
  d$sd_c <- ifelse(vt == "SE", d$var_c * sqrt(d$n_c), d$var_c)
  d$sd_t <- ifelse(vt == "SE", d$var_t * sqrt(d$n_t), d$var_t)
  # lnRR and its variance, as in the registered protocol
  d$yi <- log(d$mean_t / d$mean_c)
  d$vi <- d$sd_t^2 / (d$n_t * d$mean_t^2) + d$sd_c^2 / (d$n_c * d$mean_c^2)
  d
}
es <- make_es(dat, unclear_as = "SD")      # main run

# Cross check against metafor's own lnRR. vi must match exactly (difference 0).
# yi can differ by up to ~0.004 because escalc adds a small second order bias
# correction to lnRR: 0.5 * (sd_t^2/(n_t*mean_t^2) - sd_c^2/(n_c*mean_c^2)).
chk <- escalc(measure = "ROM", m1i = mean_t, sd1i = sd_t, n1i = n_t,
              m2i = mean_c, sd2i = sd_c, n2i = n_c, data = es)
max(abs(chk$yi - es$yi)); max(abs(chk$vi - es$vi))

# Two separate sets, never mixed
pooled <- es[es$control_type == "unamended", ]
fert   <- es[es$control_type == "fert_only", ]
pooled$pct <- round((exp(pooled$yi) - 1) * 100, 1)
fert$pct   <- round((exp(fert$yi)   - 1) * 100, 1)

# ---- STEP 3: MAIN MODELS (registered model) ----
# test = "z": registered model (z based CI).
# test = "t": small sample check. dfs = "contain" uses study level df
# (number of studies minus 1), which is right for so few studies.
fit_mv <- function(d, test = "z")
  rma.mv(yi, vi, random = ~ 1 | study_id/effect_id,
         data = d, method = "REML", test = test,
         dfs = ifelse(test == "t", "contain", "residual"))

m_pool <- fit_mv(pooled)                   # headline: manure vs unamended
m_fert <- fit_mv(fert)                     # separate: fert_only
summary(m_pool); summary(m_fert)

# ---- STEP 4: HETEROGENEITY (multilevel I2, Nakagawa and Santos) ----
het <- function(m, d) {
  w   <- 1 / d$vi
  k   <- nrow(d)
  s2m <- (k - 1) * sum(w) / (sum(w)^2 - sum(w^2))   # typical sampling variance
  t2  <- sum(m$sigma2)                              # study + effect level
  tot <- t2 + s2m
  c(Q = as.numeric(m$QE), Q_p = as.numeric(m$QEp),
    tau2_study = m$sigma2[1], tau2_effect = m$sigma2[2], tau2_total = t2,
    I2_total = 100 * t2 / tot, I2_study = 100 * m$sigma2[1] / tot,
    I2_effect = 100 * m$sigma2[2] / tot)
}

# ---- STEP 5: SUBGROUP ELIGIBILITY (every level needs 3+ studies) ----
count_sub <- function(d, var) {
  d2 <- unique(d[!is.na(d[[var]]), c("study_id", var)])
  table(d2[[var]])
}
eligible <- function(d, var) {
  n <- count_sub(d, var)
  length(n) >= 2 && all(n >= 3)
}
for (v in c("amend_type", "soil_type", "duration_group")) {
  cat("\nPOOLED:", v, "\n");    print(count_sub(pooled, v)); print(eligible(pooled, v))
  cat("\nFERT_ONLY:", v, "\n"); print(count_sub(fert, v));   print(eligible(fert, v))
}

# ---- STEP 6: SENSITIVITY ----
# Rows of study 101 (and 196) treated as SE instead of SD
es_se     <- make_es(dat, unclear_as = "SE")
es_101    <- es;  i <- es$study_id == 101;           es_101[i, ]    <- es_se[i, ]
es_196101 <- es;  i <- es$study_id %in% c(196, 101); es_196101[i, ] <- es_se[i, ]
pick <- function(d, ctrl) d[d$control_type == ctrl, ]

# One fitted row: z based CI (default) and t based CI (small sample)
pc <- function(x) round((exp(x) - 1) * 100, 1)
fit_row <- function(d, set, label) {
  mz <- fit_mv(d, "z"); mt <- fit_mv(d, "t")
  data.frame(set = set, scenario = label, k = nrow(d),
             studies = length(unique(d$study_id)),
             lnRR = round(as.numeric(mz$b), 3), pct = pc(as.numeric(mz$b)),
             lo_z = pc(mz$ci.lb), hi_z = pc(mz$ci.ub),
             lo_t = pc(mt$ci.lb), hi_t = pc(mt$ci.ub),
             tau2 = round(sum(mz$sigma2), 4))
}
loo <- function(d, set)
  do.call(rbind, lapply(unique(d$study_id), function(s)
    fit_row(d[d$study_id != s, ], set, paste("Leave out", s))))

res_pool <- rbind(
  fit_row(pooled, "pooled", "MAIN (unclear = SD)"),
  fit_row(pick(es_101, "unamended"),    "pooled", "101 as SE"),
  fit_row(pick(es_196101, "unamended"), "pooled", "196 + 101 as SE"),
  loo(pooled, "pooled"))
res_fert <- rbind(
  fit_row(fert, "fert_only", "MAIN (unclear = SD)"),
  fit_row(pick(es_101, "fert_only"),    "fert_only", "101 as SE"),
  fit_row(pick(es_196101, "fert_only"), "fert_only", "196 + 101 as SE"),
  loo(fert, "fert_only"))
print(res_pool, row.names = FALSE); print(res_fert, row.names = FALSE)

# ---- STEP 7: EXPORT (clean tables) ----
# 1. Effect sizes, every row
write.csv(es[, c("study_id","effect_id","author_year","control_type","amend_type",
                 "var_type","mean_c","mean_t","sd_c","sd_t","n_c","n_t","yi","vi")],
          "results/S6_effect_sizes.csv", row.names = FALSE)

# 2. Main results: ONE row per set (estimate, both CIs, prediction interval, tau2, Q, I2)
main_row <- function(m, d, set) {
  r <- fit_row(d, set, "MAIN")[, c("set","k","studies","lnRR","pct",
                                   "lo_z","hi_z","lo_t","hi_t")]
  # 95% prediction interval (t based, study level df), percent change
  pr <- predict(fit_mv(d, "t"), transf = pc)
  r$pi_lo <- round(pr$pi.lb, 1); r$pi_hi <- round(pr$pi.ub, 1)
  cbind(r, as.data.frame(t(round(het(m, d), 4))))
}
write.csv(rbind(main_row(m_pool, pooled, "pooled"),
                main_row(m_fert, fert, "fert_only")),
          "results/S6_main_results.csv", row.names = FALSE)

# 3. Sensitivity, 4. fert_only rows
write.csv(rbind(res_pool, res_fert), "results/S6_sensitivity.csv", row.names = FALSE)
write.csv(fert[, c("effect_id","amend_type","soil_type","duration_group","pct")],
          "results/S6_fert_descriptive.csv", row.names = FALSE)

# ---- STEP 8: BIAS CHECK (funnel plots; Egger only if 10+ studies) ----
bias_tab <- function(m) {
  d <- m$data
  out <- data.frame(study_id = d$study_id, effect_id = d$effect_id,
                    yi = round(m$yi, 3), sei = round(sqrt(m$vi), 3))
  out[order(out$sei), ]
}
write.csv(bias_tab(m_pool), "results/S7_funnel_data_pooled.csv", row.names = FALSE)
write.csv(bias_tab(m_fert), "results/S7_funnel_data_fert.csv",  row.names = FALSE)

png("results/S7_funnel_pooled.png", width = 1600, height = 1200, res = 250)
funnel(m_pool, yaxis = "sei", xlab = "lnRR", main = "Pooled (unamended)")
dev.off()
png("results/S7_funnel_fert.png", width = 1600, height = 1200, res = 250)
funnel(m_fert, yaxis = "sei", xlab = "lnRR", main = "Fert_only")
dev.off()

# Record software versions (for reproducibility)
writeLines(capture.output(sessionInfo()), "results/sessionInfo.txt")
list.files("results")
