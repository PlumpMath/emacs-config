; don't pop up a file dialog
(setq use-file-dialog nil)

; don't pop up dialog boxes
(setq use-dialog-box nil)

; say y or n instead of yes or no for prompts
(fset 'yes-or-no-p 'y-or-n-p)



; show line number in mode line
(line-number-mode 1)

; show column number in mode line
(column-number-mode 1)

;; disambiguate buffers with the same name by adding the parent director(ies)
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
