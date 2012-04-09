;; Set fill column globally to 80
(setq-default fill-column 80)

;; Automatically fill in comments
(setq-default comment-auto-fill-only-comments t)
(add-hook 'prog-mode-hook 'auto-fill-mode)

; NEVER indent with tabs
(set-default 'indent-tabs-mode nil)
