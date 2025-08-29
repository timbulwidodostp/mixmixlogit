{smcl}
{* 23Aug2012/}{...}
{cmd:help lclogit}{right: ({browse "http://www.stata-journal.com/article.html?article=st0312":SJ13-3: st0312})}
{hline}

{title:Title}

{p2colset 5 16 18 2}{...}
{p2col :{hi:lclogit} {hline 2}}Latent-class logit model via expectation-maximization algorithm{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 15 2}
{cmd:lclogit}
{depvar}
[{indepvars}] {ifin}{cmd:,}
{cmdab:gr:oup(}{varname}{cmd:)}
{cmdab:id(}{varname}{cmd:)}
{cmdab:ncl:asses(}{it:#}{cmd:)}
[{cmdab:mem:bership(}{varlist}{cmd:)}
{cmdab:conv:ergence(}{it:#}{cmd:)}
{opt iter:ate(#)}
{opt seed(#)}
{cmdab:const:raints(}{cmd:Class}{it:# {help numlist}}{cmd::} [{cmd:Class}{it:# numlist}{cmd::} ...]{cmd:)} {opt nolog}]


{title:Description}

{pstd}{cmd:lclogit} fits latent-class conditional logit models through
an expectation-maximization algorithm proposed in Bhat (1997) and Train
(2008).  The data setup is the same as for {cmd:clogit}.

{pstd}Note: Buis's (2008) {cmd:fmlogit} ({bf:{stata findit fmlogit}})
needs to be installed before {opt membership(varlist)} is used to let
the class shares depend on the choice maker's characteristics.


{title:Options}

{phang}
{opth group(varname)} specifies a numeric identifier variable for
the choice situations.  {opt group()} is required.

{phang}
{opth id(varname)} specifies a numeric identifier variable for the
choice makers or agents.  With cross-section data, users should specify
the same variable for both the {cmd:group()} and the {cmd:id()} options.
{cmd:id()} is required.

{phang}
{opt nclasses(#)} specifies the number of latent classes used in
the estimation.  A minimum of two latent classes is required.
{cmd:nclasses()} is required.

{phang}
{opt membership(varlist)} specifies independent variables to
enter the fractional multinomial logit model of class membership.  These
variables are assumed to be constant across alternatives and choice
occasions for the same agent, with age and household income being
typical examples.

{phang}
{opt convergence(#)} specifies the tolerance for the log
likelihood.  When the proportional increase in the log likelihood over
the last five iterations is less than the specified criterion,
{cmd:lclogit} declares convergence.  The default is
{cmd:convergence(0.00001)}.

{phang}
{opt iterate(#)} specifies the maximum number of iterations.  If
convergence is not achieved after the selected number of iterations,
{cmd:lclogit} stops the recursion and notes this fact before displaying
the estimation results.  The default is {cmd:iterate(150)}.

{phang}
{opt seed(#)} sets the seed for pseudouniform random numbers.
The default is the {cmd:creturn} value {cmd:c(seed)}.

{pmore}
The starting values for the taste coefficients are obtained by
splitting the sample into {opt nclasses()} different subsamples and
fitting a {cmd:clogit} model for each of them.  During this process,
a pseudouniform random number is generated for each agent to assign the
agent into a particular subsample.  As for the starting values for the
class shares, {cmd:lclogit} uses equal shares, that is,
1/{cmd:nclasses()}.

{phang}
{cmdab:constraints(}{cmd:Class}{it:#} {it:{help numlist}}{cmd::}
[{cmd:Class}{it:# numlist}{cmd::} ...]{cmd:)} specifies the constraints
that are imposed on the taste parameters of the designated classes.  For
instance, suppose that {cmd:x1} and {cmd:x2} are alternative-specific
characteristics included in {it:indepvars} for {cmd:lclogit} and that
the user wishes to restrict the coefficient on {cmd:x1} to 0 for
{cmd:Class1} and {cmd:Class4} and the coefficient on {cmd:x2} to 2 for
{cmd:Class4}.  Then the relevant series of commands would look like
this:

{phang2}{cmd:constraint 1 x1 = 0}{p_end}
{phang2}{cmd:constraint 2 x2 = 2}{p_end}
{phang2}{cmd:lclogit} 
{depvar} 
{indepvars} 
{ifin}{cmd:,}
{cmd:group(}{varname}{cmd:)} 
{cmd:id(}{varname}{cmd:)} /// {break}
{cmd:nclasses(8)}   
{cmd:constraints(Class1 1: Class4 1 2)}

{phang}
{opt nolog} suppresses the display of an iteration log.


{title:Example}

{pstd}
Consider the following example, which contains the first rows from
the data used in Huber and Train (2001).  {cmd:pid} is the agent;
{cmd:gid} is the choice situation; {cmd:y} is the dependent variable;
and {cmd:contract}, {cmd:local}, {cmd:wknown}, {cmd:tod}, and
{cmd:seasonal} are alternative-specific attributes:

{cmd}    pid   gid     y      price   contract   local   wknown   tod   seasonal
      1     1      0        7        5         0       1       0       0
      1     1      0        9        1         1       0       0       0
      1     1      0        0        0         0       0       0       1
      1     1      1        0        5         0       1       1       0
      1     2      0        7        0         0       1       0       0
      1     2      0        9        5         0       1       0       0
      1     2      1        0        1         1       0       1       0
      1     2      0        0        5         0       0       0       1{txt}

{pstd}
{cmd:lclogit} can be particularly useful for the nonparametric
estimation of mixing distributions.  Indeed, when the number of latent
classes increases, the true mixing distribution of the coefficients can
be approximated nonparametrically.

{pstd}
Latent-class models have been fit via gradient-based
algorithms, such as Newton-Raphson or Berndt-Hall-Hall-Hausman.
However, the estimation through standard optimization techniques becomes
difficult when the number of parameters increases.  In this case, an
expectation-maximization procedure could help because it requires the
repeated evaluation of a function that is far easier to maximize.

{pstd}
Clearly, the first goal when dealing with latent-class models is
to determine the optimal number of latent classes.  Train (2008) bases
this decision on goodness-of-fit measures such as the Akaike's
information criterion or the Bayesian information criterion.  Here we
show how to determine the optimal number of latent classes by using
{cmd:lclogit} and the Bayesian information criterion:

{phang2}{cmd:. use http://fmwww.bc.edu/repec/bocode/t/traindata.dta}{p_end}
{phang2}{cmd:2. forvalues c=2/11{c -(}}{p_end}
{phang2}{cmd:3.		lclogit y price contract local wknown tod seasonal, id(pid) gr(gid) ncl(`c')}{p_end}
{phang2}{cmd:4. 	scalar bic_`c'=e(bic)}{p_end}
{phang2}{cmd:5. {c )-}}{p_end}
{phang2}{cmd:6. forvalues c=2/11{c -(}}{p_end}
{phang2}{cmd:7.		display bic_`c'}{p_end}
{phang2}{cmd:8. {c )-}}{p_end}


{title:Stored results}

{pstd}{cmd:lclogit} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(N_g)}}number of choice situations identified by {cmd:group()}{p_end}
{synopt:{cmd:e(N_i)}}number of agents identified by {cmd:id()}{p_end}
{synopt:{cmd:e(nclasses)}}number of latent classes{p_end}
{synopt:{cmd:e(bic)}}Bayesian information criterion{p_end}
{synopt:{cmd:e(aic)}}Akaike information criterion{p_end}
{synopt:{cmd:e(caic)}}consistent Akaike information criterion{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:lclogit}{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(group)}}name of {cmd:group()} variable{p_end}
{synopt:{cmd:e(id)}}name of {cmd:id()} variable{p_end}
{synopt:{cmd:e(indepvars)}}names of independent variables in the choice model{p_end}
{synopt:{cmd:e(indepvars2)}}names of independent variables in the class membership model{p_end}
{synopt:{cmd:e(seed)}}pseudorandom number seed{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(B)}}matrix of taste coefficients{p_end}
{synopt:{cmd:e(P)}}vector of (estimation sample average) class shares{p_end}
{synopt:{cmd:e(PB)}}vector of weighted-average choice model coefficients, where weights = class shares{p_end}
{synopt:{cmd:e(CB)}}(estimation sample average) covariance matrix of choice model coefficients{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{title:References}

{phang}
Bhat, C. R.  1997. An endogenous segmentation mode choice model with an
application to intercity travel. {it:Transportation Science} 31: 34-48.

{phang}
Buis, M. L.  2008.  fmlogit: Stata module fitting a fractional
multinomial logit model by quasi maximum likelihood.  Statistical
Software Components S456976, Department of Economics, Boston College.
{browse "http://ideas.repec.org/c/boc/bocode/s456976.html"}.

{phang}
Huber, J., and K. Train, 2001.  On the similarity of classical
and Bayesian estimates of individual mean partworths. 
{it:Marketing Letters} 12: 259-269.

{phang}
Train, K. E.  2008.  EM algorithms for nonparametric estimation of
mixing distributions.  {it:Journal of Choice Modelling} 1: 40-69.


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

{p 4 14 2}
Article:  {it:Stata Journal}, volume 13, number 3: {browse "http://www.stata-journal.com/article.html?article=st0312":st0312}

{p 7 14 2}
Help:  {helpb lclogit postestimation}, {helpb fmlogit} (if installed)
{p_end}
