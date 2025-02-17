Function Invoke-CIPPStandardTeamsGlobalMeetingPolicy {
    <#
    .FUNCTIONALITY
        Internal
    .COMPONENT
        (APIName) TeamsGlobalMeetingPolicy
    .SYNOPSIS
        (Label) Define Global Meeting Policy for Teams
    .DESCRIPTION
        (Helptext) Defines the CIS recommended global meeting policy for Teams. This includes AllowAnonymousUsersToJoinMeeting, AllowAnonymousUsersToStartMeeting, AutoAdmittedUsers, AllowPSTNUsersToBypassLobby, MeetingChatEnabledType, DesignatedPresenterRoleMode, AllowExternalParticipantGiveRequestControl
        (DocsDescription) Defines the CIS recommended global meeting policy for Teams. This includes AllowAnonymousUsersToJoinMeeting, AllowAnonymousUsersToStartMeeting, AutoAdmittedUsers, AllowPSTNUsersToBypassLobby, MeetingChatEnabledType, DesignatedPresenterRoleMode, AllowExternalParticipantGiveRequestControl
    .NOTES
        CAT
            Teams Standards
        TAG
            "lowimpact"
        ADDEDCOMPONENT
            {"type":"autoComplete","multiple":false,"name":"standards.TeamsGlobalMeetingPolicy.DesignatedPresenterRoleMode","label":"Default value of the `Who can present?`","options":[{"label":"EveryoneUserOverride","value":"EveryoneUserOverride"},{"label":"EveryoneInCompanyUserOverride","value":"EveryoneInCompanyUserOverride"},{"label":"EveryoneInSameAndFederatedCompanyUserOverride","value":"EveryoneInSameAndFederatedCompanyUserOverride"},{"label":"OrganizerOnlyUserOverride","value":"OrganizerOnlyUserOverride"}]}
            {"type":"switch","name":"standards.TeamsGlobalMeetingPolicy.AllowAnonymousUsersToJoinMeeting","label":"Allow anonymous users to join meeting"}
            {"type":"autoComplete","multiple":false,"name":"standards.TeamsGlobalMeetingPolicy.MeetingChatEnabledType","label":"Meeting chat policy","options":[{"label":"On for everyone","value":"Enabled"},{"label":"On for everyone but anonymous users","value":"EnabledExceptAnonymous"},{"label":"Off for everyone","value":"Disabled"}]}
        IMPACT
            Low Impact
        POWERSHELLEQUIVALENT
            Set-CsTeamsMeetingPolicy -AllowAnonymousUsersToJoinMeeting \$false -AllowAnonymousUsersToStartMeeting \$false -AutoAdmittedUsers EveryoneInCompanyExcludingGuests -AllowPSTNUsersToBypassLobby \$false -MeetingChatEnabledType EnabledExceptAnonymous -DesignatedPresenterRoleMode \$DesignatedPresenterRoleMode -AllowExternalParticipantGiveRequestControl \$false
        RECOMMENDEDBY
            "CIS 3.0"
        UPDATECOMMENTBLOCK
            Run the Tools\Update-StandardsComments.ps1 script to update this comment block
    .LINK
        https://docs.cipp.app/user-documentation/tenant/standards/list-standards/teams-standards#low-impact
    #>
    ##$Rerun -Type Standard -Tenant $Tenant -Settings $Settings 'TeamsGlobalMeetingPolicy'

    param($Tenant, $Settings)
    $CurrentState = New-TeamsRequest -TenantFilter $Tenant -Cmdlet 'Get-CsTeamsMeetingPolicy' -CmdParams @{Identity = 'Global' }
    | Select-Object AllowAnonymousUsersToJoinMeeting, AllowAnonymousUsersToStartMeeting, AutoAdmittedUsers, AllowPSTNUsersToBypassLobby, MeetingChatEnabledType, DesignatedPresenterRoleMode, AllowExternalParticipantGiveRequestControl

    $StateIsCorrect = ($CurrentState.AllowAnonymousUsersToJoinMeeting -eq $Settings.AllowAnonymousUsersToJoinMeeting) -and
                        ($CurrentState.AllowAnonymousUsersToStartMeeting -eq $false) -and
                        ($CurrentState.AutoAdmittedUsers -eq 'EveryoneInCompanyExcludingGuests') -and
                        ($CurrentState.AllowPSTNUsersToBypassLobby -eq $false) -and
                        ($CurrentState.MeetingChatEnabledType -eq $Settings.MeetingChatEnabledType.value) -and
                        ($CurrentState.DesignatedPresenterRoleMode -eq $Settings.DesignatedPresenterRoleMode.value) -and
                        ($CurrentState.AllowExternalParticipantGiveRequestControl -eq $false)

    if ($Settings.remediate -eq $true) {
        if ($StateIsCorrect -eq $true) {
            Write-LogMessage -API 'Standards' -tenant $Tenant -message 'Teams Global Policy already set.' -sev Info
        } else {
            $cmdparams = @{
                Identity                                   = 'Global'
                AllowAnonymousUsersToJoinMeeting           = $Settings.AllowAnonymousUsersToJoinMeeting
                AllowAnonymousUsersToStartMeeting          = $false
                AutoAdmittedUsers                          = 'EveryoneInCompanyExcludingGuests'
                AllowPSTNUsersToBypassLobby                = $false
                MeetingChatEnabledType                     = $Settings.MeetingChatEnabledType.value
                DesignatedPresenterRoleMode                = $Settings.DesignatedPresenterRoleMode.value
                AllowExternalParticipantGiveRequestControl = $false
            }

            try {
                New-TeamsRequest -TenantFilter $Tenant -Cmdlet 'Set-CsTeamsMeetingPolicy' -CmdParams $cmdparams
                Write-LogMessage -API 'Standards' -tenant $Tenant -message 'Updated Teams Global Policy' -sev Info
            } catch {
                $ErrorMessage = Get-NormalizedError -Message $_.Exception.Message
                Write-LogMessage -API 'Standards' -tenant $Tenant -message "Failed to set Teams Global Policy. Error: $ErrorMessage" -sev Error
            }
        }
    }

    if ($Settings.alert -eq $true) {
        if ($StateIsCorrect -eq $true) {
            Write-LogMessage -API 'Standards' -tenant $Tenant -message 'Teams Global Policy is set correctly.' -sev Info
        } else {
            Write-LogMessage -API 'Standards' -tenant $Tenant -message 'Teams Global Policy is not set correctly.' -sev Alert
        }
    }

    if ($Setings.report -eq $true) {
        Add-CIPPBPAField -FieldName 'TeamsGlobalMeetingPolicy' -FieldValue $StateIsCorrect -StoreAs bool -Tenant $Tenant
    }
}
