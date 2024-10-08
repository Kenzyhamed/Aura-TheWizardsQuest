; BASIC stub
        dc.w nextstmt
        dc.w 10
	 ;;; dc.b $9e, "4109", 0
  	dc.b $9e, [start]d, 0
nextstmt
        dc.w 0
