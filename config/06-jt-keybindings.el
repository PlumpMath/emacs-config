;; KEYBOARD MAPPINGS
(if macosx-p
    (setq mac-command-modifier 'meta))

; Last macro bound to f5
(global-set-key [f5] 'call-last-kbd-macro)
