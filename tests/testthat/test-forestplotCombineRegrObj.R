library(testthat)

library(tidyverse)
set.seed(10)
cov <- tibble(ftime = rexp(200)) |> 
  mutate(fstatus = sample(0:1, n(), replace = TRUE),
         x1 = runif(n()),
         x2 = runif(n()),
         x3 = runif(n()),
         x_factor = sample(LETTERS[1:4], n(), replace = TRUE))

library(rms)
ddist <<- datadist(cov)
options(datadist = "ddist")

test_that("Check regular lm", {
  # TODO: Add tests - current code is only for coverage reasons

  fit1 <- cph(Surv(ftime, fstatus) ~ x1 + x2, data = cov)
  fit2 <- cph(Surv(ftime, fstatus) ~ x1 + x3, data = cov)

  forestplotCombineRegrObj(
    regr.obj = list(fit1, fit2),
    variablesOfInterest.regexp = "(x2|x3)",
    reference.names = c("First model", "Second model"),
    new_page = TRUE
  )

  modifyNameFunction <- function(x) {
    if (x == "x1") {
      return("Covariate A")
    }

    if (x == "x2") {
      return(expression(paste("My ", beta[2])))
    }

    return(x)
  }

  ret <- forestplotCombineRegrObj(
    regr.obj = list(fit1, fit2),
    variablesOfInterest.regexp = "(x2|x3)",
    reference.names = c("First model", "Second model"),
    rowname.fn = modifyNameFunction)
  
  expect_equal(dim(ret$estimates), c(5, 3, 1))
})

test_that("Test getModelData4Forestplot", {
  # simulated data to test
  fit1 <- cph(Surv(ftime, fstatus) ~ x1 + x2, data = cov)
  fit2 <- cph(Surv(ftime, fstatus) ~ x1 + x3, data = cov)

  # regr.obj,
  # exp = TRUE,
  # variablesOfInterest.regexp,
  # ref_labels,
  # add_first_as_ref
  data <- getModelData4Forestplot(
    regr.obj = list(fit1, fit2),
    exp = TRUE,
    variablesOfInterest.regexp = "(x2|x3)",
    add_first_as_ref = FALSE
  )
  expect_equal(
    data |> filter(column_term == "x2") |> pluck("estimate"),
    exp(coef(fit1)["x2"])
  )
  expect_equivalent(
    data |> filter(column_term == "x3") |> pluck("estimate"),
    exp(coef(fit2)["x3"])
  )
  expect_false("x1" %in% data$column_term)
  expect_length(unique(data$model_id), 2)
  
  data <- getModelData4Forestplot(
    regr.obj = list(fit1, fit2),
    exp = TRUE,
    variablesOfInterest.regexp = "(x1)",
    add_first_as_ref = FALSE
  )
  expect_equivalent(
    data |> filter(column_term == "x1" & model_id == "Model 1") |> pluck("estimate"),
    exp(coef(fit1)["x1"])
  )
  expect_equivalent(
    data |> filter(column_term == "x1" & model_id == "Model 2") |> pluck("estimate"),
    exp(coef(fit2)["x1"])
  )
  expect_true("x1" %in% data$column_term)
  expect_false("x2" %in% data$column_term)
  
  fit3 <- cph(Surv(ftime, fstatus) ~ x1 + x2 + x_factor, data = cov)
  fit4 <- cph(Surv(ftime, fstatus) ~ x1 + x3 + x_factor, data = cov)

  data <- getModelData4Forestplot(
    regr.obj = list(fit3, fit4),
    exp = TRUE,
    variablesOfInterest.regexp = "(x1|x_factor)",
    add_first_as_ref = FALSE
  )
  expect_equivalent(
    data |> filter(column_term == "x1" & model_id == "Model 1") |> pluck("estimate"),
    exp(coef(fit3)["x1"])
  )
  expect_equivalent(
    data |> filter(column_term == "x1" & model_id == "Model 2") |> pluck("estimate"),
    exp(coef(fit4)["x1"])
  )
  expect_equivalent(
    data |> filter(column_term == "x_factor" & 
                     factor == "B" &
                     model_id == "Model 1") |> 
      pluck("estimate"),
    exp(coef(fit3)["x_factor=B"])
  )
  expect_equivalent(
    data |> filter(column_term == "x_factor" & 
                     factor == "C" &
                     model_id == "Model 2") |> 
      pluck("estimate"),
    exp(coef(fit4)["x_factor=C"])
  )
  expect_true("x1" %in% data$column_term)
  expect_false("x2" %in% data$column_term)
  expect_equivalent(
    data |> filter(model_id == "Model 1") |> nrow(),
    4 + 1
  )
  expect_equivalent(
    data |> filter(model_id == "Model 2") |> nrow(),
    4 + 1
  )

  data <- getModelData4Forestplot(
    regr.obj = list(fit3, fit4),
    exp = TRUE,
    variablesOfInterest.regexp = "(x_factor)",
    add_first_as_ref = TRUE
  )
  expect_equivalent(
    data |> 
      filter(model_id == "Model 1") |>  
      filter(row_number() == 2) |> 
      pluck("estimate"),
    1
  )
  expect_equivalent(
    data |> 
      filter(model_id == "Model 2") |> 
      filter(row_number() == 2) |> 
      pluck("estimate"),
    1
  )

  data <- getModelData4Forestplot(
    regr.obj = list(m1 = fit3, m2 = fit4),
    exp = FALSE,
    variablesOfInterest.regexp = "(x_factor)",
    add_first_as_ref = TRUE
  )
  expect_equivalent(
    data |> 
      filter(model_id == "m1") |> 
      filter(row_number() == 2) |> 
      pluck("estimate"),
    0
  )
  expect_equivalent(
    data |> 
      filter(model_id == "m2") |> 
      filter(row_number() == 2) |> 
      pluck("estimate"),
    0
  )

  expect_equivalent(
    data |> 
      filter(model_id == "m1" & 
               column_term == "x_factor" & 
               factor == "B") |> 
      pluck("estimate"),
    coef(fit3)["x_factor=B"]
  )
  expect_equivalent(
    data |> 
      filter(model_id == "m2" & 
               column_term == "x_factor" & 
               factor == "C") |> 
      pluck("estimate"),
    coef(fit4)["x_factor=C"]
  )
})
