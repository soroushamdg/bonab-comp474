;;; ============================================================
;;; templates.clp
;;; Defines all deftemplates used by the laptop expert system.
;;; ============================================================
;;; User profile collected before inference begins
(deftemplate user
(slot primary-use    (type SYMBOL) (allowed-values browsing business development gaming editing))
(slot budget-level   (type SYMBOL) (allowed-values low medium high))
(slot portability    (type SYMBOL) (allowed-values yes no))
(slot screen-pref    (type SYMBOL) (allowed-values small medium large any))
(slot needs-webcam   (type SYMBOL) (allowed-values yes no)))
;;; Laptop model knowledge base entry
(deftemplate laptop
(slot model          (type STRING))
(slot year           (type INTEGER))
(slot cpu-tier       (type SYMBOL) (allowed-values low mid high))
(slot ram            (type NUMBER))
(slot storage-type   (type SYMBOL) (allowed-values ssd hdd))
(slot gpu-type       (type SYMBOL) (allowed-values integrated discrete))
(slot screen-size    (type NUMBER))
(slot weight         (type NUMBER))
(slot webcam         (type SYMBOL) (allowed-values yes no))
(slot price-tier     (type SYMBOL) (allowed-values low medium high))
(slot category       (type SYMBOL) (allowed-values business gaming ultrabook creator)))
;;; Derived system requirements inferred from user profile
(deftemplate requirement
(slot attribute      (type SYMBOL))
(slot value          (type SYMBOL))
(slot numeric-value  (type NUMBER) (default 0)))
;;; Rejection fact — model name + reason
(deftemplate rejected
(slot model          (type STRING))
(slot reason         (type STRING)))
;;; Final recommendation fact
(deftemplate recommended
(slot model          (type STRING))
(slot reason         (type STRING)))