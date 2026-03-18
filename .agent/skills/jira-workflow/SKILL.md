---
name: jira-workflow
description: Guide for creating, reviewing, and managing Jira tickets in the Credit Core (CC) project. Defines standard fields, templates, and team conventions.
---

# Skill: Jira Workflow (Credit Core)

## Context
- **Default Project**: Credit Core (`CC`)
- **Instance**: https://crecosa.atlassian.net
- **API**: Jira REST API v3 (`/rest/api/3/search/jql`)
- **Authentication**: Basic Auth with `informatica@crecosa.com` + API Token

## How to Search for Tickets
```
GET /rest/api/3/search/jql?jql=project='CC'&maxResults=10&fields=summary,status,assignee
```
- Always use `/rest/api/3/search/jql` (legacy `/search` endpoints are deprecated).
- Use `fields=summary,status,assignee,priority` to get the basic data for each ticket.

## How to Create a Ticket
Always ask the user for:
1. **Summary** (ticket title) — mandatory
2. **Type**: Story / Bug / Task / Sub-task
3. **Priority**: Highest / High / Medium / Low
4. **Description**: details, steps to reproduce (if Bug), acceptance criteria
5. **Assignee**: if not specified, leave unassigned

Minimum payload:
```json
{
  "fields": {
    "project": { "key": "CC" },
    "summary": "...",
    "issuetype": { "name": "Task" },
    "priority": { "name": "Medium" }
  }
}
```

## Ticket Statuses (Typical Flow)
- `To Do` → `In Progress` → `In Review` → `Done`
- To move status use: `POST /rest/api/3/issue/{issueKey}/transitions`

## Team Conventions
- Bug tickets must include steps to reproduce and affected environment.
- Feature tickets must include clear acceptance criteria.
- Associate sub-tasks to the parent Story whenever possible.
