;;; ============================================================
;;; main.clp
;;; Entry point for the Laptop Recommendation Expert System.
;;; Loads all modules, resets the fact base, and runs inference.
;;; ============================================================
;;; Load all system modules in dependency order
(load "templates.clp")
(load "laptop-facts.clp")
(load "requirement-rules.clp")
(load "filtering-rules.clp")
(load "recommendation-rules.clp")
;;; Reset CLIPS environment (loads deffacts into working memory)
(reset)
;;; Begin forward-chaining inference
(run)
;;; End of main.clp