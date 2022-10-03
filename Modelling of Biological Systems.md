# Modelling of Biological Systems

- [INTRODUCTION](#introduction)
  - [Syllabus](#syllabus)
  - [Introduction to modeling](#introduction-to-modeling)
    - [Dynamic systems](#dynamic-systems)
      - [Predictive models](#predictive-models)
      - [Proof of concept models](#proof-of-concept-models)
    - [Discrete models](#discrete-models)
    - [Continuous models](#continuous-models)
    - [Deterministic models](#deterministic-models)
    - [Stochastic models](#stochastic-models)
  - [Advices for presentations](#advices-for-presentations)
    - [Make the presentation understandable to everyone](#make-the-presentation-understandable-to-everyone)
    - [Do not be boring for the audience](#do-not-be-boring-for-the-audience)
    - [Do not distract the audience](#do-not-distract-the-audience)
    - [The presenter (YOU)](#the-presenter-you)
- [Discrete-Time Models](#discrete-time-models)
    - [Fibonacci population growth model](#fibonacci-population-growth-model)
    - [Exponential population growth](#exponential-population-growth)
    - [Logistic population growth](#logistic-population-growth)
    - [Natural selection in a clonal population](#natural-selection-in-a-clonal-population)
# INTRODUCTION
## Syllabus
- Introduction to Modeling (mathematical approach)
- Introduction to R programming and application with Swirl
- Writing scientific results and presenting
- Modeling biological systems
  - Discrete and Continuous time models (deterministic and stochastic)
  - Ordinary Differential Equations
  - Euler's methods and more
  - Lotka-Volterra (predator-pray)
  - Monte Carlo Methods
  - Markov chains
- Application to cancer modeling (active matter approach)

## Introduction to modeling
A **Model** is a description of a _system_. 
A **System** is any collection of interrelated _objects_.
An **Object** is some elemental unit upon which observations can be made, but whose internal structure either does not exist or is ignored.

There are different types of models.
  - Conceptual
  - Physical
  - Formal
  - Diagrammatic

There are **Fixed** or **Dynamic** models.
  - Fixed: Elements of a system are correlated by some way statically.
  - Dynamic: Depend of time. 

### Dynamic systems
Dynamic systems are systems where one or several variables change through time according to certain rules.

#### Predictive models
Models that can be used to make concrete, quantitative predictions about the future.

#### Proof of concept models
They are for general understanding.
Proof that some hypotheses explain a given behavior (theoretical or not).

### Discrete models
Models in which time proceeds in a step-wise manner. Time in this model always has positive, stepped numbers.

### Continuous models
Models in which time proceeds through a real number.

### Deterministic models
Once all parameters and initial conditions are set, the variables change in a mechanincal, _predestined_ manner.
> Multiple iterations of the same model produce the same outcome

### Stochastic models
Some variables have a randomized behavior.
> Multiple iterations of the same model produce randomized values based on an _average_ behavior.

## Advices for presentations

### Make the presentation understandable to everyone

- Put an intro / context
- Clearly explain the problem to be solved
- Do not use specific vocabulary (or define acronimes before, etc...)
- Conclude by summarizing the essential points
- Open up (perspectives) by explaining what coud be done to improve the study/to go further

### Do not be boring for the audience

- Pay attention to the aesthetics of the slides _(backgroud, font, etc...)_
- Use visual elements _(graphs, illustrations, etc...)_ **BUT EXPLAIN THEM!**
- Make logical transitions between the slides _(connect them to the oral presentation)_
- A **little bit of humor** can make the presentation more dynamic

### Do not distract the audience

- Not too much information per slide. _Otherwise the audience reads and does not listen anymore_
- Not too many illustrations or humor. (It does not look serious)
- Be consistent! (font size, alignment of elements, etc...)

### The presenter (YOU)

- Do not read sheets of paper. _It looks poorly prepared and disconnect you from the audience._
- Do not read the slides. _But use them to maje your speech._
- Do not be **fidgety**, but not too **rigid** either.
- Speak **articulately** and **slowly**. _Silence can be used to place the presentation._
- Look frequently at your audience. _Eye contact is useful._
- If you feel stressed, use the _"I am in control, I will adapt"_ manner of pedagogic approach.
- Do not **endure** your presentation

> For the next time:
> - Learn and try to remember every part of the structure of a scientific article.
> - Bring a list of diseases that you are interested in.

> Exams:
> - An **Oral** part in class. Individual, for 5 minutes. An article of your choice and its content in the cleares way.
>   - Send by e-mail the title of the chose article.
> - A **Written** part to be sent in _PDF_ by e-mail. Where oyu will have to write in group an article (max. 5 persons/group). Synthesis on research concerning a single disease of your choice and the associated studi biological models.

# Discrete-Time Models

**Discrete-time** models are sequences of numbers that follow certain rules.

### Fibonacci population growth model

The Fibonacci model assumed pairs of rabbits that start mating after one month of growth and then indefinitely reproduce a new couple of baby rabbits each month.
> Following the Fibonacci Series: 1 1 2 3 5 8 13 ... $(a_n + a_{(n-1)})$

### Exponential population growth

Consider a population of asexually reproducing individuals. In each generation, each individual produces on average $a$ offsprings. ...

### Logistic population growth

Assume that the numbero of surviving offspring that an individual produces is not constant but instead devreases with increasing population size.

- $N$ is the size of the population
- $M$ is the maximum population size
- $b$ is the maximum number of offspring an individual can produce.
- $x$ is defined as the population size relative to the maximum population.

Lets describe the logistic equations as following.

+  $N_{t+1} = a(N)N_t$
   +  $a = a(N) = b(1 - \frac{N}{M})$
+  $N_{t+1} = b(1 - \frac{N_t}{M})N_t$
+  $x_t := \frac{N_t}{M}$
+  $x_{t+1} = b(1 - x_t)x_t$
+  $x_{t+1} = bx_t - x_t^2$

The graphical method is a great way of intuitively grasping discrete-time models with one variable, sucha se the logistic growth model. <br>
It lets you know the behavior of the model by generating a graphic based on the relative population values, and tracing a function such as $x_{t-1} = x_t$ in order to find the equilibrium intersections of the model.

The equilibrium intersections are found following the _zeros_ of the equation:

$$ 
  f(\hat{x}) = \hat{x}
$$


- An equilibrium is called **locally stable** if the system converges to the equilibrium value when starting from sufficiently close by in any iteration of the model.
- When the equilibrium is **locally unstable**, the model will de-stabilize when a small perturbance is applied to it while it is in its local equilibrium.


### Natural selection in a clonal population

Let us consider how selection operates in a simple, **clonal population**.<br>
We assume that there is only a single round of reproduction following which in the parental generation dies.

- $N$ is the size of the population, now constant.
- Two genotypes:
  - Type **A** produces $k$ offspring individuals per round.
  - Type **B** produces $(1 + s)k$ offspring individuals.
- $s$ is called the _selection coefficient_.

$$
  \begin{cases}
    n_A^0 = ka(t)
    \\
    n_B^0 = (1 + s)kb(t)
  \end{cases}
$$
