(add-to-list 'load-path (concat thirdparty-dir "projectile/"))

(require 'projectile)

(defun regenerate-tags ()
  "Regenerate the project's etags using ctags."
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
(define-key projectile-mode-map (kbd "C-x f") 'projectile-jump-to-project-file)
(defalias 'projectile-refresh 'projectile-invalidate-project-cache)
(setq projectile-enable-caching t)
(projectile-global-mode)


;; (require 'helm-projectile)
;; (global-set-key (kbd "C-c h") 'helm-projectile)
