# The HomeKit Family

[![Build Status](https://travis-ci.org/wossname/homekit.family.svg?branch=master)](https://travis-ci.org/wossname/homekit.family)

## Notes on Doing Stuff

Best place to start is to install all the dependencies (of which there are
many, in three different packaging systems!). If you've already got `rake`
kicking around, you can install them all with:

    rake deps

If you haven't, it's probably easiest to `gem install rake` first. ;-) It
assumes you've already got a working Ruby installation, and a working NodeJS
installation with npm.

To run the Middleman server locally, I've wrapped it with
[foreman](http://ddollar.github.io/foreman/) because that's how I roll. You can
start the server up with:

    foreman start

and it'll be available on <http://localhost:5000/>. If you want to just build
the static site itself, you can run:

    rake build

and it will stick the output in the `build/` folder, ready to be deployed.

To deploy the site, build it first, then run:

    rake deploy

and it'll sync the contents of the `build/` folder up to S3. It assumes that
you have S3 credentials set in your environment -- the easiest way to do that
is to set environment variables for `AWS_ACCESS_KEY_ID` and
`AWS_SECRET_ACCESS_KEY`. The deploy task *doesn't* depend on the build task,
just because I want them to run as separate parts of the CI build.
Unfortunately, middleman rebuilds the external assets *every* time you launch
it (see [#1916](https://github.com/middleman/middleman/issues/1916)) and
rebuilding them three times on every CI build seemed a bit wasteful.

## Using this template for a project

I'm trying to use the git subtree merge strategy so that I can maintain a
repository with the basic template, then merge down changes to the template
into each project that uses it. That way I can more easily keep things up to
date when, for example, the Inspinia template itself is updated. So here's how
to do that.

### Updating a project with new changes to the template

With an existing project, I want to be able to apply new template changes to
that project. It should work with a git subtree merge. Here are the steps to do
so.

If the local working copy doesn't already have the remote setup for the
template, do that first, then make sure all remotes are up to date:

    git remote add template git@github.com:wossname/middleman-inspinia.git
    git remote update

Now to pull changes directly onto the master branch, check out the master
branch and run:

    git merge -s subtree template/master

That should perform a subtree merge, and should merge in changes that have
applied to the upstream template since it was last merged. I've yet to find out
how to deal with conflicts, so I'll update this at that point.

Of course the more responsible thing to do is pull changes onto a new branch
and submit a pull request:

    git checkout -b update-upstream-template
    git merge -s subtree template/master
    # Deal with any conflicts
    git push -u origin update-upstream-template
    git pull-request

That way the CI server gets to spot any suboptimal changes.
