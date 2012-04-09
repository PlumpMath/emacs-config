;; keep cursor from blinking
(blink-cursor-mode nil)

;; cua-mode: show highlighted text, rectangle mode, but no cua-keys (C-x C-c C-v cut copy paste)
(cua-selection-mode t)

;; make kill ring (clipboard) accessible outside emacs
(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

; we need shift for window movement
(setq shift-select-mode nil)

; don't need a click to copy when selecting w/ mouse
(setq mouse-yank-at-point t)

; single space after a period is a new sentence for selecting
(setq sentence-end-double-space nil)
