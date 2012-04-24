;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Hide and show method defs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'hideshow)

(defun hideshow-keybindings ()
  (local-set-key (kbd "C-c <right>") 'hs-show-block)
  (local-set-key (kbd "C-c <left>")  'hs-hide-block)
  (local-set-key (kbd "C-c <up>")    'hs-hide-all)
  (local-set-key (kbd "C-c <down>")  'hs-show-all)
  )

(add-hook 'hs-minor-mode-hook 'hideshow-keybindings)

(defun turn-on-hideshow ()
  (hs-minor-mode)
  (hideshow-keybindings)
  )
(add-hook 'python-mode-hook 'turn-on-hideshow)

;; Hide the comments too when you do a 'hs-hide-all'
(setq hs-hide-comments nil)

;; Set whether isearch opens folded comments, code, or both
;; where x is code, comments, t (both), or nil (neither)
(setq hs-isearch-open 't)

(defadvice goto-line (after expand-after-goto-line
                            activate compile)

  "hideshow-expand affected block when using goto-line in a collapsed buffer"
  (save-excursion
    (hs-show-block)))

(defadvice goto-char (after expand-after-goto-char
                            activate compile)

  "hideshow-expand affected block when using goto-char in a collapsed buffer"
  (save-excursion
    (hs-show-block)))
