(global-set-key "\M-3" "#")
(setq mac-command-key-is-meta nil)
(tool-bar-mode nil)

;;; Haskell mode
(load "/Users/malc/opt/lisp/elisp-misc/haskell-mode/haskell-mode-2.4/haskell-site-file")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)


;;;;Paredit
(add-to-list 'load-path "/Users/malc/opt/lisp/elisp-misc")
(autoload 'paredit-mode "paredit"
          "Minor mode for pseudo-structurally editing Lisp code."
          t)
(add-hook 'lisp-mode-hook (lambda () 
			    (paredit-mode +1)))


;;; Factor stuff
(add-to-list 'load-path "~/opt/factor/misc/fuel/")
(load-file "~/opt/factor/misc/fuel/fu.el")
(setq fuel-factor-root-dir "~/opt/factor/")
(server-start)
(require 'factor-mode)


;;;;Color Scheme
;(require 'color-theme)
;(color-theme-initialize)
;(color-theme-taylor)
;(color-theme-standard)
(require 'zenburn)
(zenburn)

;;;;Slime stuff
(add-to-list 'load-path "/Users/malc/opt/lisp/slime")
(add-to-list 'load-path "/Users/malc/opt/lisp/slime/contrib")
(require 'slime-autoloads)
(slime-setup `(;slime-asdf
               slime-fancy slime-tramp))
(eval-after-load "slime"
  '(progn
    (define-key slime-mode-map (kbd "RET") 'newline-and-indent)
    (define-key slime-mode-map (kbd "<return>") 'newline-and-indent)
    (define-key slime-mode-map (kbd "C-j") 'newline)))

(setq slime-lisp-implementations
      `((sbcl      ("/Users/malc/opt/lisp/sbcl/sbcl-cur/bin/sbcl")
                   :coding-system utf-8-unix)
	(clojure   ("clj-cmd")
		   :init swank-clojure-init)
        ))

(setq lisp-indent-function 'common-lisp-indent-function
      slime-complete-symbol-function 'slime-fuzzy-complete-symbol)

(add-hook 'lisp-mode-hook (lambda () (slime-mode t)))
(add-hook 'inferior-lisp-mode-hook (lambda () (inferior-slime-mode t)))

(defmacro defslime-start (name lisp args coding-system)
  `(defun ,name ()
     (interactive)
     (require 'slime)
     (slime-start :program ',lisp
                  :coding-system ',coding-system
                  :program-args ',args)))

(defslime-start sbcl
  "/Users/malc/opt/lisp/sbcl/sbcl-cur/bin/sbcl"
  nil
  utf-8-unix)

(defslime-start clojure
  "clj-cmd"
  nil
  utf-8-unix)


;;;;clojure crap - stolen from http://bc.tech.coop/blog/
(defvar clj-root (concat (expand-file-name "~") "/opt/lisp/clj/" ))
(setq load-path (append (list
			 ;(concat clj-root "slime")
			 ;(concat clj-root "slime/contrib")
			 (concat clj-root "clojure-mode")
			 (concat clj-root "swank-clojure"))
			load-path))

(require 'swank-clojure)
;(require 'swank-clojure-autoload)
(require 'clojure-mode)
;(require 'clojure-auto)

(setq swank-clojure-binary "clj-cmd")
(defvar clj-cmd)
(setenv "CLJ_CMD"
	(setq clj-cmd
	      (concat "java "
		      "-server "
		      "-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8888 "
		      "-cp "
		      (concat clj-root "clojure/clojure.jar:")
		      (concat clj-root "src/*:")
		      (concat clj-root "swank-clojure/swank/*:")
		      (concat (expand-file-name "~") "/.clojure/user.clj:")
		      (concat (expand-file-name "~") "/.clojure/*:")
		      (concat clj-root "clojure-contrib/clojure-contrib.jar:")
		      ;(concat clj-root "src/proramming-clojure/code:")
		      " clojure.lang.Repl")))

;; stuff to correspond to ~/.clojure/user.clj
(defun slime-java-describe (symbol-name)
  "Get details on Java class/instance at point."
  (interactive (list (slime-read-symbol-name "Java Class/instance: ")))
  (when (not symbol-name)
    (error "No symbol given"))
  (save-excursion
    (set-buffer (slime-output-buffer))
    (unless (eq (current-buffer) (window-buffer))
      (pop-to-buffer (current-buffer) t))
    (goto-char (point-max))
    (insert (concat "(show " symbol-name ")"))
    (when symbol-name
      (slime-repl-return)
      (other-window 1))))

(defun slime-javadoc (symbol-name)
  "Get JavaDoc documentation on Java class at point."
  (interactive (list (slime-read-symbol-name "Javadoc info for: ")))
  (when (not symbol-name)
    (error "No symbol given"))
  (set-buffer (slime-output-buffer))
  (unless (eq (current-buffer) (window-buffer))
    (pop-to-buffer (current-buffer) t))
  (goto-char (point-max))
  (insert (concat "(javadoc " symbol-name ")"))
  (when symbol-name
    (slime-repl-return)
    (other-window 1)))

(add-hook 'clojure-mode-hook
	  '(lambda ()
	     (define-key clojure-mode-map "\C-c\C-e" 'lisp-eval-last-sexp)
	     (define-key clojure-mode-map "\C-x\C-e" 'lisp-eval-last-sexp)))

(add-hook 'slime-connected-hook
	  (lambda ()
	    (interactive)
	    (slime-redirect-inferior-output)
	    (define-key slime-mode-map (kbd "C-c d") 'slime-java-describe)
	    (define-key slime-repl-mode-map (kbd "C-c d") 'slime-java-describe)
	    (define-key slime-mode-map (kbd "C-c D") 'slime-javadoc)
	    (define-key slime-repl-mode-map (kbd "C-c D") 'slime-javadoc)))

;;(org-remember-insinuate)


;;remember mode stuff
;;(require 'my-remember-frame)
(add-to-list 'load-path
	     "/Users/malc/opt/lisp/elisp-misc/org-mode/lisp")
(add-to-list 'load-path
             "/Users/malc/opt/lisp/elisp-misc/org-mode/contrib/lisp")

(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(add-hook 'org-mode-hook 'turn-on-font-lock)

(add-to-list 'load-path 
	     "/Users/malc/opt/lisp/elisp-misc/remember")
(require 'remember)

(defadvice remember-finalize (after delete-remember-frame activate)
  "Advise remember-finalize to close the frame if it is the remember frame"
  (if (equal "remember" (frame-parameter nil 'name))
      (delete-frame)))

(defadvice remember-destroy (after delete-remember-frame activate)
  "Advise remember-destroy to close the frame if it is the remember frame"
  (if (equal "remember" (frame-parameter nil 'name))
      (delete-frame)))

;; make the frame contain a single window. by default org-remember
;; splits the windows
(add-hook 'remember-mode-hook
	  'delete-other-windows)

(defun make-remember-frame ()
  "Create a new frame and run org-remember."
  (interactive)
  (make-frame '((name . "remember") (width . 80) (height . 10)))
  (select-frame-by-name "remember")
  (org-remember))

(global-set-key "\C-x\C-m" 'execute-extended-command)
