use inc::Module::Install;
name 'Plack-Middleware-GoogleAnalytics';
all_from 'lib/Plack/Middleware/GoogleAnalytics.pm';
readme_from 'lib/Plack/Middleware/GoogleAnalytics.pm';
readme_markdown_from 'lib/Plack/Middleware/GoogleAnalytics.pm';
readme_pod_from 'lib/Plack/Middleware/GoogleAnalytics.pm';
githubmeta;

# requires '';
requires 'Plack';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
build_requires 'HTTP::Request::Common';
auto_set_repository;
auto_include;
WriteAll;
