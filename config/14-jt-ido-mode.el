(ido-mode t)
(ido-ubiquitous t)

;; Don't just prefix match
(setq ido-enable-prefix nil)

;; Enable flex matching
(setq ido-enable-flex-matching t)

;; Don't switch to file browsing mode
(setq ido-auto-merge-work-directories-length nil)

;; Always create a new buffer if no match found
(setq ido-create-new-buffer 'always)

;; Be smart about auto-filling ido menu
(setq ido-use-filename-at-point 'guess)

;; Keep recently closed files in ido buffers
(setq ido-use-virtual-buffers t)

(setq ido-handle-duplicate-virtual-buffers 2)

;; Max number of options to show
(setq ido-max-prospects 12)

;; Make ido vertical instead of horizontal
(setq ido-decorations (quote ("\n> " "" "\n  " "\n ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))
(defun ido-disable-line-trucation () (set (make-local-variable 'truncate-lines) nil))
(add-hook 'ido-minibuffer-setup-hook 'ido-disable-line-trucation)
