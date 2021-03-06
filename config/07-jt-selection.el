;; keep cursor from blinking
(blink-cursor-mode -1)

;; cua-mode: show highlighted text, rectangle mode, but no cua-keys (C-x C-c C-v cut copy paste)
(cua-selection-mode t)

;; make kill ring (clipboard) accessible outside emacs
(if linux-p
    (progn (setq x-select-enable-clipboard t)
           (setq interprogram-paste-function 'x-cut-buffer-or-selection-value)))

; we need shift for window movement
(setq shift-select-mode nil)

; don't need a click to copy when selecting w/ mouse
(setq mouse-yank-at-point t)

; single space after a period is a new sentence for selecting
(setq sentence-end-double-space nil)

;; Show results of undo, yank
(require 'volatile-highlights)
(volatile-highlights-mode t)

;; expand-region
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

;; copy name to clipboard
(defun copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "Copied buffer file name '%s' to the clipboard." filename))))
