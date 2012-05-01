(setq vc-dir-markers-alist '(".hg" ".git" ".svn"))

;; hacks for ido-mode, colors in debug
(load-file (concat library-dir "jt-vc-hg.el"))

;; take sane default
(defun vc-dir-default ()
  (interactive)
  (find-files-and-run-fn vc-dir-markers-alist
                         (lambda (dir fname) (vc-dir dir))))

(global-set-key (kbd "C-x v d") 'vc-dir-default)
