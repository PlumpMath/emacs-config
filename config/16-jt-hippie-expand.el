;; Hippie expand (from emacs starter kit)
(dolist (f '(try-expand-line try-expand-list try-complete-file-name-partially))
  (delete f hippie-expand-try-functions-list))
(add-to-list 'hippie-expand-try-functions-list 'try-complete-file-name-partially t)

(global-set-key (kbd "M-/") 'hippie-expand)
