(setq vc-dir-markers-alist '(".hg" ".git" ".svn"))

;; take sane default
(defun vc-dir-default ()
  (interactive)
  (find-files-and-run-fn vc-dir-markers-alist
                         (lambda (dir fname) (vc-dir dir))))

(global-set-key (kbd "C-x v d") 'vc-dir-default)
