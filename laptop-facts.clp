;;; ============================================================
;;; laptop-facts.clp
;;; Defines all laptop model instances in the knowledge base.
;;; Also contains a sample user fact for testing.
;;; ============================================================
;;; ----------------------------------------------------------
;;; Laptop 1 — Lenovo ThinkPad E14 Gen 4
;;; Category: Business ultrabook
;;; ----------------------------------------------------------
(deffacts laptop-knowledge-base
(laptop (model "Lenovo ThinkPad E14 Gen 4")
(year 2023)
(cpu-tier mid)
(ram 16)
(storage-type ssd)
(gpu-type integrated)
(screen-size 14)
(weight 1.4)
(webcam yes)
(price-tier medium)
(category business))
;;; Laptop 2 — ASUS ROG Strix G15
;;; Category: Gaming powerhouse
(laptop (model "ASUS ROG Strix G15")
(year 2023)
(cpu-tier high)
(ram 16)
(storage-type ssd)
(gpu-type discrete)
(screen-size 15.6)
(weight 2.3)
(webcam yes)
(price-tier high)
(category gaming))
;;; Laptop 3 — Apple MacBook Air M2
;;; Category: Ultrabook for light creative and dev use
(laptop (model "Apple MacBook Air M2")
(year 2023)
(cpu-tier high)
(ram 8)
(storage-type ssd)
(gpu-type integrated)
(screen-size 13.6)
(weight 1.24)
(webcam yes)
(price-tier high)
(category ultrabook))
;;; Laptop 4 — Acer Aspire 3
;;; Category: Budget browsing machine
(laptop (model "Acer Aspire 3")
(year 2022)
(cpu-tier low)
(ram 8)
(storage-type ssd)
(gpu-type integrated)
(screen-size 15.6)
(weight 1.9)
(webcam yes)
(price-tier low)
(category business))
;;; Laptop 5 — Dell XPS 15
;;; Category: Creator / developer premium
(laptop (model "Dell XPS 15")
(year 2023)
(cpu-tier high)
(ram 32)
(storage-type ssd)
(gpu-type discrete)
(screen-size 15.6)
(weight 1.86)
(webcam yes)
(price-tier high)
(category creator))
;;; Laptop 6 — HP Pavilion 15
;;; Category: Mid-range general purpose
(laptop (model "HP Pavilion 15")
(year 2022)
(cpu-tier mid)
(ram 12)
(storage-type ssd)
(gpu-type integrated)
(screen-size 15.6)
(weight 1.75)
(webcam yes)
(price-tier medium)
(category business))
;;; Laptop 7 — MSI GF63 Thin
;;; Category: Budget gaming entry
(laptop (model "MSI GF63 Thin")
(year 2022)
(cpu-tier mid)
(ram 8)
(storage-type ssd)
(gpu-type discrete)
(screen-size 15.6)
(weight 1.86)
(webcam yes)
(price-tier medium)
(category gaming))
;;; Laptop 8 — Lenovo IdeaPad Flex 5
;;; Category: Lightweight 2-in-1 for students
(laptop (model "Lenovo IdeaPad Flex 5")
(year 2023)
(cpu-tier mid)
(ram 16)
(storage-type ssd)
(gpu-type integrated)
(screen-size 14)
(weight 1.5)
(webcam yes)
(price-tier medium)
(category ultrabook))
)

;;; ----------------------------------------------------------
;;; Sample user fact — modify for each test case
;;; Test Case 1: Developer, medium budget, portability yes
;;; ----------------------------------------------------------
;;; (deffacts sample-user
;;; (user (primary-use    development)
;;; (budget-level   medium)
;;; (portability    yes)
;;; (screen-pref    medium)
;;; (needs-webcam   yes))
;;; )