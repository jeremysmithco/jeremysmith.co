---
title: Five Types of Internal Documentation Needed for Software Teams
date: 2017-03-18 20:10 UTC
tags: web
---

As I see it, there are five types of internal documentation needed for software teams.

(Often, a software team will produce external documentation for their end users, in the form of a help section, user guides, or a searchable knowledge base. But the following are categories of documentation I see as being necessary internally, for the team itself.)

## 1. Internal Application Documentation

This type of documentation is the most obvious. Software teams need to document the applications they build, explaining how they work so that other team members (now and in the future) can manage, improve, or change the system. Internal application documentation often comes in the form of a detailed README in the code repository, which includes instructions for setting up, testing, deploying and changing the codebase. It describes library dependencies and integrations with other systems. Internal application documentation also documents the internal API of the system, which may include class and module-level documentation, preferably written in the same place the code is implemented.

## 2. Change Documentation

Software teams also need to document the individual changes they make to the application. These may be new features, refactorings, or bug fixes. This documentation should include the what, why, and how for the changes being made. This is often stored in a project management system, with task lists and team member responsibility. It's often cross-referenced to commits made in the version control system, so that code changes can be traced back to their original context and rationale in the future.

## 3. Process Documentation

There are often many processes around managing and supporting the application that need to be documented for clear definition and standardization. These procedures may range from how to set up a pristine production environment, to how to recover from (and respond to) specific incidents. This type of documentation is sometimes called a runbook. [Gitlab has a good open source example of this.](https://gitlab.com/gitlab-com/runbooks)

## 4. Architectural Documentation

The longer a software project runs, the harder it is to remember how and why specific architectural decisions were made. There's often important context that is lost over time, and can lead to wasted effort either trying to recall or reconstruct previous rationale, or making new decisions without understanding previous considerations that may still be important. Michael Nygard describes how this can be documented in his blog post, [Documenting Architecture Decisions](http://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions).

## 5. Organization Documentation

Outside of the given software project, every team needs documentation for their big picture philosophy, their explanation of "how we do things here." Creating consistency (from tool usage, to coding style, to general project processes) helps reduce confusion and wasted time. The [thoughtbot playbook](https://thoughtbot.com/playbook) is a prime example of this.

With these five types of documentation, there's a clear place for communicating every type of important information about creating, extending, and managing an application.
