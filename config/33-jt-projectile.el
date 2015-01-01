(require 'projectile)

(defun regenerate-tags ()
  "Regenerate the project's etags using ctags. 

   Ignores files included in the .ctags_excludes folder in the
   root of the project (where the .git or .hg folder is located)
  "
  (interactive)
  (let ((current-dir default-directory)
        (project-root (projectile-get-project-root))
        (exclude-args ""))
    (cd project-root)
    (if (file-exists-p ".ctags_excludes")
        (setq exclude-args "--exclude=@.ctags_excludes"))
    (shell-command (format "ctags -Re --python-kinds=-i %s %s" exclude-args project-root))
    (cd current-dir)
    (visit-tags-table project-root)))
(defalias 'etags 'regenerate-tags)

;; find in project
(define-key projectile-mode-map (kbd "C-x f") 'projectile-find-file)

(setq projectile-file-exists-remote-cache-expire (* 10 60))
(setq projectile-enable-caching t)
(projectile-global-mode)


;; (require 'helm-projectile)
;; (global-set-key (kbd "C-c h") 'helm-projectile)
