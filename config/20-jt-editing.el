
;; From Emacs Prelude
(defun duplicate-current-line-or-region (arg)
  "Duplicates the current line or region ARG times.
If there's no region, the current line will be duplicated. However, if
there's a region, all lines that region covers will be duplicated."
  (interactive "p")
  (let (beg end (origin (point)))
    (if (and mark-active (> (point) (mark)))
        (exchange-point-and-mark))
    (setq beg (line-beginning-position))
    (if mark-active
        (exchange-point-and-mark))
    (setq end (line-end-position))
    (let ((region (buffer-substring-no-properties beg end)))
      (dotimes (i arg)
        (goto-char end)
        (newline)
        (insert region)
        (setq end (point)))
      (goto-char (+ origin (* (length region) arg) arg)))))

(defun move-line-up ()
  "Move up the current line."
  (interactive)
  (transpose-lines 1)
  (previous-line 2))

(defun move-line-down ()
  "Move down the current line."
  (interactive)
  (next-line 1)
  (transpose-lines 1)
  (previous-line 1))

;; code borrowed from http://emacs-fu.blogspot.com/2010/01/duplicating-lines-and-commenting-them.html
(defun duplicate-line-and-comment (&optional commentfirst)
  "comment line at point; if COMMENTFIRST is non-nil, comment the
original" (interactive)
  (beginning-of-line)
  (push-mark)
  (end-of-line)
  (let ((str (buffer-substring (region-beginning) (region-end))))
    (when commentfirst
    (comment-region (region-beginning) (region-end)))
    (insert-string
      (concat (if (= 0 (forward-line 1)) "" "\n") str "\n"))
    (forward-line -1)))

;; Mark whole line
(defun mark-line (&optional arg)
  "Marks a line"
  (interactive "p")
  (beginning-of-line)
  (push-mark (point) nil t)
  (end-of-line))

(require 'autopair)
(defun turn-autopair-mode-on ()
  (autopair-mode))
(setup-multiple-hooks '(lisp-mode-hook
                        emacs-lisp-mode-hook
                        text-mode-hook
                        c-mode-common-hook
                        python-mode-hook)
                      'turn-autopair-mode-on)

;; duplicate a line
(global-set-key (kbd "C-c d") 'duplicate-current-line-or-region)
;; duplicate a line and comment the first
(global-set-key (kbd "C-c c")(lambda()(interactive)(duplicate-line-and-comment t)))
(global-set-key (kbd "C-c l") 'mark-line)
(global-set-key [(control shift up)] 'move-line-up)
(global-set-key [(control shift down)]  'move-line-down)

;; Merge 2 lines
(global-set-key (kbd "C-c j") 'join-line)
