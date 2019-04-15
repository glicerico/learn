; Perform unit tests for the MST-parsing part of the ULL pipeline.

(use-modules (opencog test-runner))

(opencog-test-runner)
; Name of test-suite
(define suite-name "MST-parse-test")

; Setup

(load "setup.scm") ; custom unit-test utilities

(define test-str-1 "The first test-sentence.")
(define test-str-2 "The second one")

;-------------------------------------------------------
; Begin test
(test-begin suite-name)

; Open the database.
(sql-open "postgres:///MST-parse-test")

; First mode to check: mst without distance
(define mst-dist #f)

; Only create word-pairs that have positive counts
; otherwise there's a problem when calculating MI
(define word-pair-atoms
	(list
		; First sentence possible pairs
		(make-word-pair "###LEFT-WALL###" "The" cnt-mode 0)
		(make-word-pair "###LEFT-WALL###" "first" cnt-mode 0)
		(make-word-pair "The" "first" cnt-mode 0)
		(make-word-pair "The" "test-sentence." cnt-mode 0)
		(make-word-pair "first" "test-sentence." cnt-mode 0)
		; Second sentence possible pairs
		(make-word-pair "###LEFT-WALL###" "second" cnt-mode 0)
		(make-word-pair "The" "second" cnt-mode 0)
		(make-word-pair "The" "one" cnt-mode 0)
		(make-word-pair "second" "one" cnt-mode 0)
	)
)

; Counts that each pair should have been observed, considering a
; clique window of 2
; First pair appears on both sentences
(define counts-list
	(list 2 1 1 1 1 1 1 1 1)
)

; Set the counts for each pair as if it was observed
(for-each
	(lambda (atom count)
		(set-atom-count atom count)
	)
	word-pair-atoms counts-list
)

; Run ULL pipeline to calculate MI
(comp-mi cnt-mode)

; manually calculated, expected MI values for each pair in the list
(define MI-list
	(list (- (log2 5) 1) (- (log2 5) 2) (- (log2 5) 2) (- (log2 5) 2) (log2 5)
	(- (log2 5) 2) (- (log2 5) 2) (- (log2 5) 2) (log2 5))
)
(define tolerance 0.000001) ; tolerated diff between MI-values

; Test that the MI values were calculated correctly by pipeline
(define check-MI-text "Checking correct MI values clique")

(for-each
	(lambda (atom expected-MI)
		(define diff (- (get-MI-value atom) expected-MI))
		(test-assert check-MI-text (< (abs diff) tolerance))
	)
	word-pair-atoms MI-list
)

; -------------------------------------------------
; Close testing database and suite
(sql-close)

(test-end suite-name)
