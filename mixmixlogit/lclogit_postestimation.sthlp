{smcl}
{* 23Aug2012/}{...}
{cmd:help lclogit postestimation}{right: ({browse "http://www.stata-journal.com/article.html?article=st0312":SJ13-3: st0312})}
{hline}

{title:Title}

{p2colset 5 31 33 2}{...}
{p2col :{hi:lclogit postestimation} {hline 2}}Postestimation tools for
lclogit{p_end}
{p2colreset}{...}


{title:Description}

{pstd}The following postestimation commands are available after
{cmd:lclogit}:

{synoptset 12}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
{synopt:{helpb lclogit postestimation##lclogitpr:lclogitpr}}predict the
probabilities of choice and class membership{p_end}
{synopt:{helpb lclogit postestimation##lclogitcov:lclogitcov}}predict the
implied covariances of choice model coefficients{p_end}
{synopt:{helpb lclogit postestimation##lclogitml:lclogitml}}pass active {cmd:lclogit} estimates to {cmd:gllamm}{p_end}
{synoptline}


{marker lclogitpr}{...}
{title:Syntax for lclogitpr}

{p 8 15 2}
{cmd:lclogitpr} {it:stubname} {ifin}
[{cmd:,} {cmdab:cl:ass(}{it:{help numlist}}{cmd:)}
	{opt pr0}
	{opt pr}
	{opt up}
	{opt cp}]


{title:Description for lclogitpr}

{pstd}{cmd:lclogitpr} predicts the probabilities of choosing each
alternative in a choice situation (choice probabilities hereafter), the
class shares or prior probabilities of class membership, and the
posterior probabilities of class membership.  The predicted
probabilities are stored in a set of variables named {it:stubname#}
where {it:#} refers to the relevant class number; the only exception is
the unconditional choice probability, which is stored in a variable
named {it:stubname}.

{pstd}The command assumes {opt pr} when no other option is specified.


{title:Options for lclogitpr}

{phang}{cmdab:class(}{it:numlist}{cmd:)} specifies the classes for which
the probabilities are going to be predicted.  The default setting
assumes all classes.

{phang}{opt pr0} predicts the unconditional choice probability, which
equals the average of the class-specific choice probabilities weighted
by the corresponding class shares.

{phang}{opt pr} predicts the unconditional choice probability and the
choice probabilities conditional on being in particular classes.  This
is the default option.

{phang}{opt up} predicts the class shares or prior probabilities that
the agent is in particular classes.  They correspond to the class shares
predicted by using the class membership model coefficient estimates.

{phang}{opt cp} predicts the posterior probabilities that the agent is
in particular classes, taking into account his or her sequence of
choices.


{marker lclogitcov}{...}
{title:Syntax for lclogitcov}

{p 8 15 2}
{cmd:lclogitcov} {varlist} {ifin}
[{cmd:,} {opt nokeep}
	{opt var:name(stubname)}
	{opt cov:name(stubname)}
	{opt mat:rix(name)}]


{title:Description for lclogitcov}

{pstd}{cmd:lclogitcov} predicts the implied variances and covariances of
choice model coefficients by using {cmd:lclogit} or {cmd:lclogitml}
estimates; see Hess et al. (2011) for details.  They could be a useful
tool for studying the underlying pattern of tastes.

{pstd}The default setting stores the predicted variances in a set of
variables named {cmd:var_1}, {cmd:var_2}, ..., where {cmd:var_}{it:k} is
the predicted variance of the coefficient on the kth variable listed in
{it:varlist}, and to store the predicted covariances in {cmd:cov_12},
{cmd:cov_13}, ..., {cmd:cov_23}, ..., where {cmd:cov_}{it:kj} is the
predicted covariance between the coefficients on the kth variable and
the jth variable in {it:varlist}.

{pstd} The averages of these variances and covariances across agents (as
identified by {cmd:id()} in {cmd:lclogit}) in the prediction sample are
reported as a covariance matrix at the end of {cmd:lclogitcov}'s
execution.


{title:Options for lclogitcov}

{phang}{opt nokeep} drops the predicted variances and covariances from
the dataset at the end of the command's execution.  The average
covariance matrix is still displayed.

{phang}{opt varname(stubname)} requests that the predicted variances be
stored as {it:stubname}{cmd:1}, {it:stubname}{cmd:2}, ....

{phang}{opt covname(stubname)} requests that the predicted covariances
be stored as {it:stubname}{cmd:12}, {it:stubname}{cmd:13}, ....

{phang}{opt matrix(name)} stores the reported average covariance matrix
in a Stata matrix called {it:name}.


{marker lclogitml}{...}
{title:Syntax for lclogitml}

{p 8 15 2}
{cmd:lclogitml}
{ifin}
[{cmd:,} {cmdab:iter:ate(}{it:#}{cmd:)}
	{cmdab:l:evel(}{it:#}{cmd:)}
	{opt nopo:st}
	{opt swit:ch}
	{it:compatible_gllamm_options}]


{title:Description for lclogitml}

{pstd}{cmd:lclogitml} is a wrapper for {cmd:gllamm} 
({bf:{stata findit gllamm}}) (Rabe-Hesketh, Skrondal, and Pickles 2002),
which uses the {cmd:d0} method to fit generalized linear
latent-class and mixed models, including the latent-class conditional
logit model.  This postestimation command passes active {cmd:lclogit}
model specification and estimates to {cmd:gllamm}, and its primary use
mainly depends on how {opt iterate(#)} is specified; see below for
details.

{pstd}The default setting relabels and transforms the {cmd:ereturn}
results of {cmd:gllamm} in accordance with those of {cmd:lclogit} before
reporting and posting them.  Users can exploit {cmd:lclogitpr} and
{cmd:lclogitcov}, as well as Stata's usual postestimation commands
requiring the estimated covariance matrix such as {cmd:nlcom}.  When
{cmd:switch} is specified, the original {cmd:ereturn} results of
{cmd:gllamm} are reported and posted; users gain access to
{cmd:gllamm}'s postestimation commands but lose access to
{cmd:lclogitpr} and {cmd:lclogitcov}.

{pstd}{cmd:lclogitml} can also be used as its own postestimation
command, for example, to pass the currently active {cmd:lclogitml}
results to {cmd:gllamm} for further Newton-Raphson iterations.


{title:Options for lclogitml}

{phang}{opt iterate(#)} specifies the maximum number of Newton-Raphson
iterations for {cmd:gllamm}'s likelihood-maximization process.  The
default is {cmd:iterate(0)}, in which case the likelihood function and
its derivatives are evaluated at current {cmd:lclogit} estimates; this
allows for obtaining standard errors associated with the current
estimates without bootstrapping.

{p 8 8 2}With a nonzero argument, this option can implement a hybrid
estimation strategy similar to Bhat's (1997).  He executes a relatively
small number of expectation-maximization iterations to obtain
intermediate estimates and uses them as starting values for direct
likelihood maximization via a quasi-Newton algorithm until convergence
because the expectation-maximization algorithm tends to slow down near
the local maximum.

{p 8 8 2}Specifying a nonzero argument for this option can also be a
useful tool for checking whether {cmd:lclogit} has declared convergence
prematurely (for instance, because {cmd:convergence()} has not been set
stringently enough for an application at hand).

{phang}{opt level(#)} sets the confidence level.  The default is
{cmd:level(95)}.

{phang}{opt nopost} restores the currently active {cmd:ereturn} results
at the end of the command's execution.

{phang}{opt switch} displays and posts the original {cmd:gllamm}
estimation results without relabeling and transforming them in
accordance with the {cmd:lclogit} output.

{phang}{it:compatible_gllamm_options} refer to {cmd:gllamm}'s estimation
options, which are compatible with the latent-class logit model
specification.  See {helpb gllamm} for more information.


{title:Stored results}

{pstd}By default, {cmd:lclogitml} stores the following in {cmd:e()}, in
addition to what is stored for {cmd:lclogit} except {cmd:e(seed)}.  When
{opt nopost} is specified, the currently active {cmd:ereturn} results
are restored at the end of the command's execution.  When {cmd:switch}
is specified, {cmd:lclogitml} stores the same set of results in
{cmd:e()} as {cmd:gllamm}.

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:lclogitml}{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{p2colreset}{...}


{title:References}

{phang}Bhat, C. R.  1997.  An endogenous segmentation mode choice model
with an application to intercity travel.  {it:Transportation Science}
31: 34-48.

{phang}Hess, S., M. Ben-Akiva, D. Gopinath, and J. Walker.  2011.
Advantages of latent class over continuous mixture of logit models.
{browse "http://www.stephanehess.me.uk/papers/Hess_Ben-Akiva_Gopinath_Walker_May_2011.pdf"}.

{phang}Rabe-Hesketh, S., A. Skrondal, and A. Pickles.  2002.  {browse "http://www.stata-journal.com/article.html?article=st0005":Reliable estimation of generalized linear mixed models using adaptive quadrature}.
{it:Stata Journal} 2: 1-21.


{title:Authors}

{pstd}Comments and suggestions are welcome.

{pstd}Daniele Pacifico{p_end}
{pstd}Italian Department of the Treasury{p_end}
{pstd}Rome, Italy{p_end}
{pstd}daniele.pacifico@tesoro.it{p_end}

{pstd}Hong il Yoo{p_end}
{pstd}Durham University Business School{p_end}
{pstd}Durham University{p_end}
{pstd}Durham, UK{p_end}
{pstd}h.i.yoo@durham.ac.uk{p_end}


{title:Also see}

{p 4 14 2}Article:  {it:Stata Journal}, volume 13, number 3: {browse "http://www.stata-journal.com/article.html?article=st0312":st0312}

{p 7 14 2}Help:  {helpb lclogit}, {helpb gllamm} (if installed){p_end}
