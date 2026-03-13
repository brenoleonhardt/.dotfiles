(load (expand-file-name "lisp/xdg.el" user-emacs-directory))
;; (add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
;; (require 'xdg)

(defun reload-config ()
  (interactive)
  (load-file user-init-file))
