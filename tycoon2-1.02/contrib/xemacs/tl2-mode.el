;;; tl2-mode.el -- tl2 mode, and its idiosyncratic commands.

;;; Author: Axel Wienberg <ax.wienberg@tuhh.de>

;;; This file is under GPL.

;;; Commentary:
;;;  Originally a query-replace of scheme mode,
;;;  but without all the indentation stuff (which leaves = ?)
;;;  Still to do: proper comment handling

;; Insert something like the following in your .emacs:
;;(setq load-path
;;  (cons (concat (getenv "HOX_HOME") "/../contrib/xemacs")
;;	  load-path))
;;(autoload 'tl2-mode "tl2-mode" "mode for editing tl2 code" t)
;;(autoload 'run-tl2 "tl2" "run tl2" t)
;;(if (not (assoc "\\.tyc$" auto-mode-alist))
;;    (setq auto-mode-alist
;;	  (append '(("\\.tyc$" . tl2-mode)
;;		    ("\\.tc$" . tl2-mode))
;;		auto-mode-alist)))
;;(setq tl2-program-name 
;;	(concat (getenv "HOX_HOME")
;;              "/bin/"
;;              (getenv "HOX_HOST")
;;              "/tycoon2 TL2.ts"))
;;(setq tl2-default-directory 
;;	(concat (getenv "HOX_HOME") "/"))
;;(load "tl2-wizards")
;;(resize-minibuffer-mode)


;;; Code:


(defvar tl2-mode-syntax-table nil "")
(if (not tl2-mode-syntax-table)
    (let ((table (make-syntax-table))
	  (i 0))
	  
      ;; Default is atom-constituent.
      (while (< i 256)
	(modify-syntax-entry i "_" table)
	(setq i (1+ i)))

      ;; Word components.
      (setq i ?0)
      (while (<= i ?9)
	(modify-syntax-entry i "w" table)
	(setq i (1+ i)))
      (setq i ?A)
      (while (<= i ?Z)
	(modify-syntax-entry i "w" table)
	(setq i (1+ i)))
      (setq i ?a)
      (while (<= i ?z)
	(modify-syntax-entry i "w" table)
	(setq i (1+ i)))

      ;; Whitespace
      (modify-syntax-entry ?\t " " table)
      (modify-syntax-entry ?\n " " table)
      (modify-syntax-entry ?\f " " table)
      (modify-syntax-entry ?\r " " table)
      (modify-syntax-entry ?   " " table)

      ;; These characters are delimiters but otherwise undefined.
      ;; Brackets and braces balance for editing convenience.
      (modify-syntax-entry ?[ "(]" table)
      (modify-syntax-entry ?] ")[" table)
      (modify-syntax-entry ?{ "(}" table)
      (modify-syntax-entry ?} "){" table)
      (modify-syntax-entry ?* "_ 23" table)

      ;; Other atom delimiters
      (modify-syntax-entry ?\( "() 1" table)
      (modify-syntax-entry ?\) ")( 4" table)
      (modify-syntax-entry ?\; "." table)
      (modify-syntax-entry ?\" "\"" table)
      (modify-syntax-entry ?\' "\"" table)

      ;; Special characters
      (modify-syntax-entry ?\\ "\\" table)

      (setq tl2-mode-syntax-table table)))


(defvar tl2-mode-abbrev-table nil "")
(define-abbrev-table 'tl2-mode-abbrev-table ())

(defun tl2-mode-variables ()
  (set-syntax-table tl2-mode-syntax-table)
  (setq local-abbrev-table tl2-mode-abbrev-table)
  (make-local-variable 'paragraph-start)
  (setq paragraph-start (concat "^$\\|" page-delimiter))
  (make-local-variable 'paragraph-separate)
  (setq paragraph-separate paragraph-start)
  (make-local-variable 'paragraph-ignore-fill-prefix)
  (setq paragraph-ignore-fill-prefix t)
  (make-local-variable 'indent-line-function)
  (setq indent-line-function 'indent-relative)
;  (make-local-variable 'parse-sexp-ignore-comments)
;  (setq parse-sexp-ignore-comments t)
;  (make-local-variable 'comment-start)
;  (setq comment-start ";")
;  (make-local-variable 'comment-start-skip)
;  (setq comment-start-skip ";+[ \t]*")
;  (make-local-variable 'comment-column)
;  (setq comment-column 40)
;  (make-local-variable 'comment-indent-function)
;  (setq comment-indent-function 'tl2-comment-indent)
;  (make-local-variable 'parse-sexp-ignore-comments)
;  (setq parse-sexp-ignore-comments t)
  (setq mode-line-process '("" tl2-mode-line-process)))

(defvar tl2-mode-line-process "")

(defun tl2-mode-commands (map)
  ; (define-key map "\t" 'indent-relative)
  (define-key map "\n" 'newline-and-indent)
  ;(define-key map "\177" 'backward-delete-char-untabify)
  )

(defvar tl2-mode-map nil)
(if (not tl2-mode-map)
    (progn
      (setq tl2-mode-map (make-sparse-keymap))
      (tl2-mode-commands tl2-mode-map)))

;;;###autoload
(defun tl2-mode ()
  "Major mode for editing Tl2 code.
Editing commands are similar to those of lisp-mode.

In addition, if an inferior Tl2 process is running, some additional
commands will be defined, for evaluating expressions and controlling
the interpreter, and the state of the process will be displayed in the
modeline of all Tl2 buffers.  The names of commands that interact
with the Tl2 process start with \"tl2-\".  For more information
see the documentation for inferior-tl2-mode.

Commands:
Delete converts tabs to spaces as it moves back.
Blank lines separate paragraphs.  (* *) surrounds comments.
\\{tl2-mode-map}
Entry to this mode calls the value of tl2-mode-hook
if that value is non-nil."
  (interactive)
  (kill-all-local-variables)
  (tl2-mode-initialize)
  (tl2-mode-variables)
  (run-hooks 'tl2-mode-hook))

(defun tl2-mode-initialize ()
  (use-local-map tl2-mode-map)
  (set-syntax-table tl2-mode-syntax-table)
  (setq major-mode 'tl2-mode)
  (setq mode-name "Tl2"))

(provide 'tl2-mode)

;;; tl2-mode.el ends here
