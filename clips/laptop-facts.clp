;;; ============================================================
;;; laptop-facts.clp
;;; ============================================================

(deffacts laptop-knowledge-base

   ;;; ----------------------------------------------------------
   ;;; Laptop 1 — Lenovo ThinkPad E14 Gen 6 (Intel, 2025)
   ;;; CPU: Intel Core Ultra 7 155U (Meteor Lake, mid-high)
   ;;; Source: lenovo.com, xda-developers review Jan 2025
   ;;; ----------------------------------------------------------
   (laptop (model "Lenovo ThinkPad E14 Gen 6")
           (year 2025)
           (cpu-tier mid)
           (ram 16)
           (storage-type ssd)
           (gpu-type integrated)
           (screen-size 14)
           (weight 1.42)
           (webcam yes)
           (price-tier medium)
           (category business))

   ;;; ----------------------------------------------------------
   ;;; Laptop 2 — ASUS ROG Strix G16 (2025) G615
   ;;; CPU: Intel Core Ultra 9 275HX | GPU: RTX 5080 (discrete)
   ;;; RAM: 32GB DDR5-5600 | Weight: 2.34 kg
   ;;; Source: rog.asus.com/us/laptops/rog-strix/rog-strix-g16-2025
   ;;; ----------------------------------------------------------
   (laptop (model "ASUS ROG Strix G16 2025")
           (year 2025)
           (cpu-tier high)
           (ram 32)
           (storage-type ssd)
           (gpu-type discrete)
           (screen-size 16)
           (weight 2.34)
           (webcam yes)
           (price-tier high)
           (category gaming))

   ;;; ----------------------------------------------------------
   ;;; Laptop 3 — Apple MacBook Air 13 M4 (2025)
   ;;; CPU: Apple M4 (10-core) | GPU: integrated 10-core
   ;;; RAM: 16GB unified | Weight: 1.24 kg
   ;;; Source: apple.com/macbook-air/specs, Tom's Hardware Mar 2025
   ;;; ----------------------------------------------------------
   (laptop (model "Apple MacBook Air M4 13")
           (year 2025)
           (cpu-tier high)
           (ram 16)
           (storage-type ssd)
           (gpu-type integrated)
           (screen-size 13.6)
           (weight 1.24)
           (webcam yes)
           (price-tier high)
           (category ultrabook))

   ;;; ----------------------------------------------------------
   ;;; Laptop 4 — Acer Aspire 3 (2025)
   ;;; CPU: AMD Ryzen 7 7730U (8-core Zen 3 Refresh)
   ;;; RAM: 16GB DDR4 | Weight: 1.79 kg (3.94 lbs)
   ;;; Source: amazon.com verified listing, acer.com spec sheet
   ;;; ----------------------------------------------------------
   (laptop (model "Acer Aspire 3 2025")
           (year 2025)
           (cpu-tier mid)
           (ram 16)
           (storage-type ssd)
           (gpu-type integrated)
           (screen-size 15.6)
           (weight 1.79)
           (webcam yes)
           (price-tier low)
           (category business))

   ;;; ----------------------------------------------------------
   ;;; Laptop 5 — Dell XPS 15 9530 (current 2025 availability)
   ;;; CPU: Intel Core i7-13700H | GPU: RTX 4070 (discrete)
   ;;; RAM: 32GB DDR5 | Weight: 1.86 kg
   ;;; Source: dell.com/en-us/shop/dell-laptops/xps-15-laptop
   ;;; ----------------------------------------------------------
   (laptop (model "Dell XPS 15 9530")
           (year 2025)
           (cpu-tier high)
           (ram 32)
           (storage-type ssd)
           (gpu-type discrete)
           (screen-size 15.6)
           (weight 1.86)
           (webcam yes)
           (price-tier high)
           (category creator))

   ;;; ----------------------------------------------------------
   ;;; Laptop 6 — HP Pavilion Plus 16 (2025)
   ;;; CPU: Intel Core Ultra 7 155H (mid-high) | GPU: integrated Arc
   ;;; RAM: 16GB DDR5 | Weight: 1.85 kg
   ;;; Source: hp.com product page, hp.com/us-en/shop/pdp/hp-pavilion-plus-16
   ;;; ----------------------------------------------------------
   (laptop (model "HP Pavilion Plus 16 2025")
           (year 2025)
           (cpu-tier mid)
           (ram 16)
           (storage-type ssd)
           (gpu-type integrated)
           (screen-size 16)
           (weight 1.85)
           (webcam yes)
           (price-tier medium)
           (category business))

   ;;; ----------------------------------------------------------
   ;;; Laptop 7 — MSI Thin GF63 12th Gen (2025 market availability)
   ;;; CPU: Intel Core i7-12650H (mid) | GPU: RTX 3050 (discrete)
   ;;; RAM: 16GB DDR4 | Weight: 1.86 kg
   ;;; Source: us.msi.com/Laptop/Thin-GF63-12UX, Tom's Hardware review
   ;;; ----------------------------------------------------------
   (laptop (model "MSI Thin GF63 12th Gen")
           (year 2025)
           (cpu-tier mid)
           (ram 16)
           (storage-type ssd)
           (gpu-type discrete)
           (screen-size 15.6)
           (weight 1.86)
           (webcam yes)
           (price-tier medium)
           (category gaming))

   ;;; ----------------------------------------------------------
   ;;; Laptop 8 — Lenovo IdeaPad Flex 5 Gen 9 (2025)
   ;;; CPU: AMD Ryzen 7 8745HS (mid) | GPU: integrated Radeon 780M
   ;;; RAM: 16GB DDR5 | Weight: 1.49 kg
   ;;; Source: lenovo.com/us/en/laptops/ideapad/flex-series
   ;;; ----------------------------------------------------------
   (laptop (model "Lenovo IdeaPad Flex 5 Gen 9")
           (year 2025)
           (cpu-tier mid)
           (ram 16)
           (storage-type ssd)
           (gpu-type integrated)
           (screen-size 14)
           (weight 1.49)
           (webcam yes)
           (price-tier medium)
           (category ultrabook))

;;; ----------------------------------------------------------
   ;;; Laptop 9 — Microsoft Surface Laptop 7 (13.8", 2025)
   ;;; CPU: Qualcomm Snapdragon X Plus (10-core, high-tier ARM)
   ;;; GPU: Qualcomm Adreno (integrated) | RAM: 16GB LPDDR5X
   ;;; Weight: 1.34 kg | Price starts at $999
   ;;; Source: windowscentral.com review, microsoft.com/surface
   ;;; ----------------------------------------------------------
   (laptop (model "Microsoft Surface Laptop 7 13.8")
           (year 2025)
           (cpu-tier high)
           (ram 16)
           (storage-type ssd)
           (gpu-type integrated)
           (screen-size 13.8)
           (weight 1.34)
           (webcam yes)
           (price-tier high)
           (category ultrabook))

   ;;; ----------------------------------------------------------
   ;;; Laptop 10 — Samsung Galaxy Book5 Pro 16" (2025)
   ;;; CPU: Intel Core Ultra 7 256V (Series 2) | GPU: Intel Arc 140V
   ;;; RAM: 16GB LPDDR5X | Weight: 1.56 kg | Price: $1,649
   ;;; Source: windowscentral.com review, samsung.com/us/computing
   ;;; ----------------------------------------------------------
   (laptop (model "Samsung Galaxy Book5 Pro 16")
           (year 2025)
           (cpu-tier mid)
           (ram 16)
           (storage-type ssd)
           (gpu-type integrated)
           (screen-size 16)
           (weight 1.56)
           (webcam yes)
           (price-tier high)
           (category creator))

   ;;; ----------------------------------------------------------
   ;;; Laptop 11 — Razer Blade 16 (2025)
   ;;; CPU: AMD Ryzen AI 9 HX 370 (high) | GPU: RTX 5090 (discrete)
   ;;; RAM: 32GB DDR5 | Weight: 2.1 kg | Price: from $4,499
   ;;; Source: notebookcheck.net review (March 2025), razer.com
   ;;; ----------------------------------------------------------
   (laptop (model "Razer Blade 16 2025")
           (year 2025)
           (cpu-tier high)
           (ram 32)
           (storage-type ssd)
           (gpu-type discrete)
           (screen-size 16)
           (weight 2.1)
           (webcam yes)
           (price-tier high)
           (category gaming))

   ;;; ----------------------------------------------------------
   ;;; Laptop 12 — Lenovo Legion Pro 5i Gen 10 (2025)
   ;;; CPU: Intel Core Ultra 9 275HX (high) | GPU: RTX 5070 (discrete)
   ;;; RAM: 32GB DDR5 | Weight: ~2.4 kg (0.15 kg/inch * 16)
   ;;; Source: laptopdecision.com, ultrabookreview.com (Dec 2025)
   ;;; ----------------------------------------------------------
   (laptop (model "Lenovo Legion Pro 5i Gen 10")
           (year 2025)
           (cpu-tier high)
           (ram 32)
           (storage-type ssd)
           (gpu-type discrete)
           (screen-size 16)
           (weight 2.4)
           (webcam yes)
           (price-tier high)
           (category gaming))

   ;;; ----------------------------------------------------------
   ;;; Laptop 13 — LG Gram 16 (2025)
   ;;; CPU: Intel Core Ultra 7 (Series 2, mid) | GPU: integrated Arc
   ;;; RAM: 16GB | Weight: 1.4 kg (lightest 16" class available)
   ;;; Source: lg.com/us/laptops, digitaltrends.com review
   ;;; ----------------------------------------------------------
   (laptop (model "LG Gram 16 2025")
           (year 2025)
           (cpu-tier mid)
           (ram 16)
           (storage-type ssd)
           (gpu-type integrated)
           (screen-size 16)
           (weight 1.4)
           (webcam yes)
           (price-tier high)
           (category ultrabook))

   ;;; ----------------------------------------------------------
   ;;; Laptop 14 — HP Spectre x360 14 (2025)
   ;;; CPU: Intel Core Ultra 7 155H (mid) | GPU: integrated Arc
   ;;; RAM: 16GB LPDDR5 | Weight: 1.45 kg | Price: ~$1,499
   ;;; Source: notebookcheck.net, rtings.com comparison data
   ;;; ----------------------------------------------------------
   (laptop (model "HP Spectre x360 14 2025")
           (year 2025)
           (cpu-tier mid)
           (ram 16)
           (storage-type ssd)
           (gpu-type integrated)
           (screen-size 14)
           (weight 1.45)
           (webcam yes)
           (price-tier high)
           (category creator))

   ;;; ----------------------------------------------------------
   ;;; Laptop 15 — ASUS Zenbook 14 OLED (2025)
   ;;; CPU: AMD Ryzen 9 8945HS (high) | GPU: integrated Radeon 780M
   ;;; RAM: 32GB LPDDR5 | Weight: 1.39 kg | Price: ~$1,199 (medium)
   ;;; Source: asus.com/laptops/zenbook, notebookcheck.net
   ;;; ----------------------------------------------------------
   (laptop (model "ASUS Zenbook 14 OLED 2025")
           (year 2025)
           (cpu-tier high)
           (ram 32)
           (storage-type ssd)
           (gpu-type integrated)
           (screen-size 14)
           (weight 1.39)
           (webcam yes)
           (price-tier medium)
           (category ultrabook))

   ;;; ----------------------------------------------------------
   ;;; Laptop 16 — Dell Inspiron 15 3000 (2025)
   ;;; CPU: Intel Core i5-1335U (low-mid) | GPU: integrated UHD
   ;;; RAM: 16GB DDR4 | Weight: 1.83 kg | Price: ~$549 (low)
   ;;; Source: dell.com/en-us/shop/laptops/inspiron, amazon listings
   ;;; ----------------------------------------------------------
   (laptop (model "Dell Inspiron 15 3000 2025")
           (year 2025)
           (cpu-tier low)
           (ram 16)
           (storage-type ssd)
           (gpu-type integrated)
           (screen-size 15.6)
           (weight 1.83)
           (webcam yes)
           (price-tier low)
           (category business))

)

;;; ----------------------------------------------------------
;;; Sample user fact is intentionally omitted here.
;;; Assert user facts directly in test-case files after (reset).
;;; ----------------------------------------------------------
