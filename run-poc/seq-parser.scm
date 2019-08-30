;
; seq-parser.scm
;
; Sequential Maximum Spanning Tree parser.
;
; Copyleft 2019 Andres Suarez Madrigal
;
; ---------------------------------------------------------------------
; OVERVIEW
; --------
; An implementation of the MST-parser propsed by Deniz Yuret in his
; PhD thesis.

(use-modules (opencog))

(define (pop-right-links index STACK)
	"Pop right-links of index from stack"
	#f ; TODO
)

(define (get-min-link LINK)
	"get min(LINK, minlink[RIGHT-WORD(LINK)])"
	#f ; TODO
)

(define (get-max-MI LIST)
	"Get max MI value from links in the stack"
	#f ; TODO
)

(define (unlink link)
	"Remove link from link-list
	"
	#f ; TODO
)

(define (get-left-links index)
	"Search in link-list for links to the left of given index.
	Return those links in a list"
	#f ; TODO
)

; ---------------------------------------------------------------------
(define-public (seq-mst-parse ATOM-LIST SCORE-FN)
"
  Sequential, projective, undirected Maximum Spanning Tree parser.


"
	(define stack '()) 
	(define last-link #f)
	(define minlink  ; initialize; will store minimum valued links
		(make-list (- (length ATOM-LIST) 1) #f)
	)
	(define curr-MI 0)
	(define link-list '())

	; traverse sentence from left to right
	(do
		((j 0 (1+ j)))
		((= j (length ATOM-LIST)))

		; try to connect current word with every word to its left
		(do
			((i (- j 1) (1- i))) ; start from word to the left of current word
			((< i 0)) ; downto the first word

			(if (not (null? stack))
				(set! last-link (pop-right-links i stack))
			)
			(if last-link
				(list-set! minlink i (get-min-link last-link))
			)
			(set! curr-MI (SCORE-FN curr-link dist))
			(set! curr-link '('(i wL) '(j wR) curr-MI)) ; TODO: get words
			(if 
				(and
					(> curr-MI 0)
					(> curr-MI (SCORE-FN (list-ref minlink i) dist))
					(> curr-MI (get-max-MI stack))
				)
				(begin
					(for-each unlink stack) ; unlink crossing links
					(set! stack '()) ; reset stack
					(unlink (list-ref minlink i)) ; unlink weakest link in cycles
					(list-set! minlink i curr-link)
					(list link-list curr-link) ; accept current link
				)
			)

			(append stack (get-left-links i))
		)
	)

)