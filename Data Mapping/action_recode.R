action_recode <- function(empstats, action, reasoncd, retirement_eligibility) {
  work_state = "Unknown"
  if (!is.na(empstats)) {
    if (empstats == "2") {
      work_state = "STD"
    } else if (empstats == "3") {
      work_state = "LTD"
    } else if (empstats == "4" || empstats == "5" || empstats == "8" || empstats == "9" || empstats == "D" || empstats == "T") {
      if (!is.na(retirement_eligibility)) {
        if (retirement_eligibility == 0) {
          work_state = "Terminate"
        } else if (retirement_eligibility == 1) {
          work_state = "Retire"
        }
      } else {
        work_state = "Terminate"
      }
    } else if (empstats == "6") {
      work_state = "LOA"
    } else if (empstats == "L" || empstats == "P") {
      if (!is.na(action)) {
        if (action == "Leave of Absence" || action == "LEAVE OF ABSENCE" || action == "Paid Leave of Absence") {
          if (!is.na(reasoncd)) {
            if (reasoncd == "FMLA" || reasoncd == "Military" || reasoncd == "MILIT") {
              work_state = "FMLA"
            } else {
              work_state = "LOA"
            }
          } else {
            work_state = "LOA"
          } 
        } else if (action == "Short Term Disability" || action == "SHORT TERM DISABILITY") {
          work_state = "STD" 
        } else if (action == "Long Term Disability" || action == "LONG TERM DISABILITY") {
          work_state = "LTD"
        } else {
          work_state = "LOA"
        }
      } else {
        work_state = "LOA"
      }
    } else if (empstats == "7" || empstats == "Q" || empstats == "R") {
      work_state = "Retire"
    } else if (empstats == "A") {
      work_state = "Work"
    } else if (empstats == "S") {
      work_state = "Suspend"
    } else if (empstats == "I") {
      if (!is.na(action)) {
        if (action == "New Status") {
          work_state = "Work"
        }
      }
    } else if (empstats == "N") {
      if (!is.na(action)) {
        if (action == "Position Name" || action == "Transferred" || action == "Lateral") {
          work_state = "Work"
        }
      }
    } else if (empstats == "O") {
      if (!is.na(action)) {
        if (action == "Leave - Personal/Paid" || action == "Leave - Workers Comp" || action == "Leave - Educational" || action == "Leave - Union") {
          work_state = "LOA"
        } else if (action == "New Position" || action == "In Range Incr" || action == "Leave Layoff" || action == "Business Unit"
                   || action == "Position Eval" || action == "Position Change" || action == "Performance" || action == "New Status"
                   || action == "New Position" || action == "Job Category" || action == "Audit Review" || action == "Hrly Pos Reeval"
                   || action == "Audit Change??" || action == "Contract Change" || action == "Audit Change Only" || action == "Salary Adj"
                   || action == "BU Name" || action == "Special Adjust") {
          work_state = "Work"
        } else if (action == "Leave - Military" || action == "Leave - Familiy (FMLA)") {
          work_state = "FMLA"
        } else if (action == "Layoff - Separation") {
          work_state = "Suspend"
        } else if (action == "Layoff - Hourly: Benefits Expi" || action == "Layoff - Temporary/Regular" || action == "Layoff - Permanent(Obsolete 1"
                   || action == "Layoff - Dept Shutdown" || action == "Layoff - Disciplinary" || action == "Layoff - Plant Shutdown") {
          work_state = "Terminate"
        } else if (action == "Leave - Disability") {
          work_state = "STD"
        } else if (action == "Leave - Long Term Disability") {
          work_state = "LTD"
        }
      }
    } else if (empstats == "0" || empstats == "J" || empstats == "X") {
      work_state = "Unknown"
    }
  } else {
    if (!is.na(action)) {
      if (action == "Leave of Absence Education" || action == "Paid Leave" || action == "Leave of Absence Unpaid" || action == "Leave of Absence Union"
          || action == "Leave of Absence Worker's Compensation" || action == "Leave of Absence Union Business Agent") {
        work_state = "LOA"
      } else if (action == "Hire" || action == "Active Assignment" || action == "Active Probation") {
        work_state = "Work"
      } else if (action == "Leave of Absence FMLA" || action == "Leave of Absence Military" || action == "Paid Leave Military") {
        work_state = "FMLA"
      } else if (action == "Layoff Legacy" || action == "Suspended Disciplinary" || action == "Layoff Separation") {
        work_state = "Suspend"
      } else if (action == "Terminated" || action == "Layoff Plant Shut Down Union" || action == "Only Use SBE" || action == "Layoff Union Use Only SBE"
                 || action == "Layoff Special ISP" || action == "Layoff SBE" || action == "Layoff Plant Shut Down no SBE" || action  == "Layoff Plant Shut Down SBE"
                 || action == "Layoff Department Shut Down" || action == "Layoff Benefit Expired" || action == "Layoff No SBE") {
        if (!is.na(retirement_eligibility)) {
          if (retirement_eligibility == 0) {
            work_state = "Terminate"
          } else {
            work_state = "Retire"
          }
        } else {
          work_state = "Terminate"
        }   
      } else if (action == "Leave of Absence STD") {
        work_state = "STD"
      } else if (action == "Leave of Absence LTD" || action == "Leave of Absence Legacy") {
        work_state = "LTD"
      }
    }
  }
  return(work_state)
}