(defun c-mode-common-hook-fn ()
  (interactive)
  (subword-mode +1)
  (setq c-basic-offset 4)
  (which-function-mode t) ; show fn in modeline (resource hogs)?
  (c-toggle-syntactic-indentation 1) ; respect syntax
  (c-toggle-hungry-state nil) ; delete whitespace
  (c-toggle-electric-state 1) ; reindent on periods
  (define-key c-mode-base-map (kbd "C-c h") 'ff-find-other-file) ; find header and implementation files
  )

(add-hook 'c-mode-common-hook 'c-mode-common-hook-fn)

(global-set-key (kbd "C-c k") 'comment-region)
(global-set-key (kbd "C-c u") 'uncomment-region)
