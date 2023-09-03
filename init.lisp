(defpackage #:lem-my-init
  (:use #:cl
        #:lem)
  (:import-from #:lem/frame-multiplexer
                #:frame-multiplexer))
(in-package :lem-my-init)

(setf *scroll-recenter-p* nil)

(let ((asdf:*central-registry* (cons #P"~/.lem/" asdf:*central-registry*)))
  (ql:quickload :lem-my-init))

(define-command slime-qlot-exec (directory) ((prompt-for-directory (format nil "Project directory (~A): " (buffer-directory))))
  (let ((command (first (lem-lisp-mode/implementation::list-roswell-with-qlot-commands))))
    (when command
      (lem-lisp-mode:run-slime command :directory directory))))

(add-hook *after-init-hook*
          (lambda ()
            (setf (variable-value 'frame-multiplexer :global) nil))
          -1)

#+lem-ncurses
(progn
  (define-command suspend-editor () ()
    (charms/ll:endwin)
    (sb-posix:kill (sb-posix:getpid) sb-unix:sigtstp))

  (define-key *global-keymap* "C-z" 'suspend-editor))
