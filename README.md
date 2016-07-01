# Crystallography-Optimization
Machine Learning based search for Optimal Crystallization Conditions

Sanjit Singh Batra, Jayadeva, Munishwar Nath Gupta


The task in crystallography, is to find a condition, which gives a clear crystal. The only ability that we have, is to be able to choose any random condition, and evaluate whether or not we get a crystal( or how "good" a crystal we get.)

The task in reinforcement learning is to find a point x*, where the reward function R is maximized. And, we are armed with the ability to be able to compute R, at any random point, x, of our choice.

In both cases, the search space is, in general, quite large, and hence we require a method that arrives at such a crystallization condition( or x* ), "quickly". 

Every Reinforcement learning problem, can be converted to a Supervised learning problem in the following way: we sample R, at a set of points, { (x_i, R(x_i) }, and learn the function h, that best approximates R, using these points. However, for h to be able to solve the Reinforcement learning problem of finding the x*, where R is maximized, h is allowed to be a poor approximation for R, but h should at least be a good approximation for the maxima of R. 

Drawing from this, we devise the following approach:
Consider any crystallization experiment. In the lab, for a set of different conditions, each condition, described by a vector x_i, compute the "extent of crystallization"(R(x_i)), as a numeric value, scaled to between 0 and100, say. Now, we learn a function h, using these pairs of values, { x_i,R(x_i) }. However, since we need that h should be able to approximate the maxima of R, we now find all the local maxima of h. We consider this new set of points as { x_i', R( x_i)' }. If we learn a new function h(2), which approximates these points, then it is clear, that h' is a good approximation of the maxima of R. 

We extend this approach, by further finding the local maxima of h(2) and learning a function h(3) from them. In this process, as we can see from the figure, assuming that the landscape of R, has been sampled uniformly, i.e. these samples were not localized, we would expect to eventually reach a function h(n), such that the local maximum of h, is the global maximum of R. At this point, we have reached a condition	where, there is a high probability that the crystallization condition would be the point at which h(n) has its local maxima, or very close to it, depending on the numerical error in learning the functions, h(i).

We considered the crystallization experimental data, obtained from the tool, AutoSherlock. The data is in the form of vectors, x_i, describing the conditions under which the experiments were carried out and associated with each condition, is a "score" for the crystal so obtained. This is score lies between 0 and 100, where 100 means a pure crystal.

We carry out the process, as above and eventually reach a point, where the local maxima of h(n) are wither very few in number, or are the same as those of h(n+1). At this stage, we  validate whether we have obtained a condition which indeed gives a "good" crystal.
