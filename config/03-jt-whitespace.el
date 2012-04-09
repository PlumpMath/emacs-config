;; Show whitespace in red
(require 'whitespace)
(setq whitespace-style
      '(face empty space-before-tab space-after-tab trailing))
(global-whitespace-mode)


;; Indent if in a programming mode
;; (defvar programming-major-modes
;;   '(emacs-lisp-mode scheme-mode lisp-mode c-mode c++-mode objc-mode latex-mode plain-tex-mode java-mode python-mode)
;;   "List of programming modes")

;; (defadvice yank (after indent-region activate)
;;   (if (member major-mode programming-major-modes)
;;       (let ((mark-even-if-inactive t))
;;         (indent-region (region-beginning) (region-end) nil))))

;; (defadvice yank-pop (after indent-region activate)
;;   (if (member major-mode programming-major-modes)
;;       (let ((mark-even-if-inactive transient-mark-mode))
;;         (indent-region (region-beginning) (region-end) nil))))
