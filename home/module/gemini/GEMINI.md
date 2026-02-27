<!-- LTeX: language=en-GB -->

# Global context

Look for documentation material such as markdown files. If they contain code
conventions, tips or contributing instructions, respect them. Project specific
instructions are always the highest priority ones.

Conciseness is preferred to bloat, unless specified otherwise at the project
level. Stay direct in things like messages, strings, comments… Comments might
lack words needed to be grammatically correct if they are still understandable.

My native language is French, but most of my projects are English only. In
project where there’s French, keep it tightly contained to it’s defined domain ;
i.e. user facing strings and documentation (often including comments), but not
symbols names.

When you wrote code, always ensure as much as you can that it works before
stopping. It should always compile without errors, preferably without warnings.
Depending on the project, it should launch so you can quickly test it, or pass
all the automated tests without errors, lint without errors… If there’s
automated tests, we at least want to maintain coverage above 80 %.
