#Requires AutoHotkey v2.0

:*:newtestplan:: {
    SendText "## Test plan`n**Risk** - **LEVEL**`n - *Risk reasoning*`n`n**Setup**`n - **Env**: `n**Revision**: ``XXXXXXXXXXXXXXXXXXXXXXXXX```n**Config**: N/A `n`n**Changes**`n*Change description*`n - Test case`n`n**Regression**`n*Regression description*`n - Test case`n`n**Automation**`n - Full XXX Automation Run - **RESULTS** - XXX failures`n`n**Deploy / Observability**`n - Deploy type`n`n"
}

:*:newreleasenotes:: {
    SendText "Case_description_goes_here.`n**Dev/Test**: Peter Scriven`n**Code Review**: TBC`n**Test Review**: TBC"
}