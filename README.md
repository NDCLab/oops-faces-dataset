# [Oops Faces: NDC-CCN Collaboration]

## Project Goal
Build on a prior study [(Buzzell et al., 2017)](https://www.jneurosci.org/content/jneuro/early/2017/02/13/JNEUROSCI.1202-16.2017.full.pdf?versioned=true) that showed after detecting an error, there is a brief reduction in stimulus-evoked activity for the following trial when the RSI is small, applying a face encoding model with varied emotional valence.

## Background & Design
Previous work in stimulus discrimination research has found that error detection reduces stimulus-evoked activity for the next trial when the RSI is small, but not when the RSI is large [(Buzzell et al., 2017)](https://www.jneurosci.org/content/jneuro/early/2017/02/13/JNEUROSCI.1202-16.2017.full.pdf?versioned=true). We will test this finding in the context of face encoding while varying emotional valence, while keeping our future goals in mind of studying how this mechanism may differ across individuals (specifically adolescents) with social anxiety. We quantify stimulus-evoked activity through EEG signals with source localization from MRI. 

Stimuli will be created using [FaReT](https://github.com/fsotoc/FaReT), a recent open source toolbox to create realistic computerized face models.

Prior to beginning the study, participants will fill out a series of questionnaires to assess anxiety levels (both generalized and social). Participants will perform a two-choice (counterbalanced) perceptual decision-making task, in which they will be instructed to determine if the second face presented contained a higher intensity emotion than the first face. Faces presented will vary in identity (also modifying gender and race to prevent adaptation and an own-race-bias) and will contain either a happy or angry facial expression. The first stimulus will be a pedestal of either 67.4% angry or 57.7% happy, corresponding to d’=2.5 for each emotion found in a pilot study. The first 100 trials will be titrated to ensure an accuracy rate of ~80% using an accelerated stochastic approximation staircase procedure (without EEG). The stimulus level value after titration will be used to create the second face for half of the trials in the main task, with the pedestal shown for the other half of the trials. RSIs will be randomized from 200-1200ms.  


## Roadmap
**Release 1:** Anticipated Q3 2022
 


## Work in Development
This `main` branch contains completed releases for this project. For all work-in-progress, please switch over to the `dev` branches.


## Contributors
| Name | Role |
| ---  | ---  |
| Emily R. Martin | Project Administration |
| George A. Buzzell | Supervision |
| Fabian A. Soto | Supervision |

Learn more about us [here](https://www.ndclab.com/people).

## Contributing
If you are interested in contributing, please read our [CONTRIBUTING.md](CONTRIBUTING.md) file.
