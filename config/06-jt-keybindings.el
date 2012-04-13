;; KEYBOARD MAPPINGS
(if macosx-p
    (setq mac-command-modifier 'meta))

; Last macro bound to f5
(global-set-key [f5] 'call-last-kbd-macro)

;; Help should search more than just commands
(global-set-key (kbd "C-h a") 'apropos)

;; tail a log file
(defalias 'tail 'auto-revert-tail-mode)
