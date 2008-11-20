;; context.lisp

(in-package #:libxml2.xpath)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; xpath-parser-context
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(libxml2.tree::defwrapper xpath-parser-context %xmlXPathParserContext)


;;; with-register-xpath-funtions

(defmacro with-xpath-functions ((&rest funcs) &body body)
  `(let ((*lisp-xpath-functions* (list ,@funcs)))
     ,@body))

;;; defxpathfun

(defvar *parser-context*)


(defun value-push (val &optional (ctxt *parser-context*))
  (%valuePush ctxt
              (make-xpath-object val)))

;; (defmethod value-push ((val boolean) &optional (ctxt *parser-context*))
;;   (%valuePush ctxt
;;               (%xmlXPathNewBoolean (if val 1 0))))

                         
(defmacro defxpathfun (name (&rest args) &body body)
  (declare (ignore args))
  `(defcallback ,name :void ((%ctxt %xmlXPathParserContextPtr) (%nargs :int))
     (declare (ignore %nargs))
     (value-push (let ((*parser-context* (make-instance 'xpath-parser-context
                                                        :pointer %ctxt)))
                   ,@body)
                 %ctxt)))

