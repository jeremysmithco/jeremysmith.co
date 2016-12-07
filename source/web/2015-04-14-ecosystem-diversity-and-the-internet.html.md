---
title: Ecosystem diversity & the Internet
date: 2015-04-14 14:47 UTC
tags:
---

I was an interdisciplinary studies major in college. Instead of looking at the world from one discipline's perspective, I was taught to pull together the methods and insights from multiple disciplines when studying something or trying to solve a problem.

Over the last couple years, I've been learning about ecology. And, of course, in the back of my mind, I'm always wondering how ecological principles might apply in other domains.

## Ecosystem health requires diversity

One of the things I've learned from ecology is that ecosystem health requires diversity. In fact, one way you can measure the health of an ecosystem is by counting the number of relationships among all the organisms in the system.

Imagine all the living things (plants, animals, fungi, microorganisms) in an ecosystem. Then imagine strings going from each organism to all the things it benefits from. The wolf benefits from the deer it eats. The deer benefits from the tree it eats from. Microorganisms in the soil benefit from the deer's droppings. Plants and trees benefit from the microorganisms processing of deer's droppings, making nutrients accessible to them. Fungi benefit from living on the roots of plants. And on and on.

When you're done, you end up with a tangled web of strings, tying all parts of the ecosystem together. The more different kinds of organisms, the more potential niches that can be filled in the system, the more redundancy in those niches, and the more relationships that can be formed. Filled roles and redundancy in those roles protects the ecosystem from threats.

Let's say you have a forest dominated by one kind of tree, and that tree is invaded by a pest that spreads through the population, killing most of them. Because of a lack of diversity in trees, there's a loss of habitat for the animals that made there homes in and near those trees, there's a loss of leaf canopy for shade-loving plants growing beneath those trees. Suddenly, it's not just that species of tree that's under threat. All the other organisms that benefited from that tree are now under pressure.

If the forest was not dominated by a single kind of tree, but contained many different species, the pressure from that pest invasion would be significantly less, and the risk to the whole ecosystem would be minimal.

## How this relates to the Internet

Last week, I was reading Jeff Atwood’s post, [Given Enough Money, All Bugs Are Shallow](http://blog.codinghorror.com/given-enough-money-all-bugs-are-shallow/). He reflects on the Heartbleed SSL vulnerability:
> The Heartbleed SSL vulnerability was a turning point for Linus's Law, a catastrophic exploit based on a severe bug in open source software. How catastrophic? It affected about 18% of all the HTTPS websites in the world, and allowed attackers to view all traffic to these websites, unencrypted... for two years.

One of his suggestions for the short term was, "create more alternatives to OpenSSL for ecosystem diversity." More alternatives to OpenSSL would not have removed the vulnerability from OpenSSL, but it would have reduced the risk to the whole system. A threat to OpenSSL would only pressure those who were using OpenSSL. And, as soon as that threat was realized, that population using OpenSSL could have migrated to an unthreatened alternative.

Natural ecosystems are threatened by pest invasions, weather events, and physical catastrophes. The threats to the Internet as an ecosystem are economic, political, and criminal.

Heartbleed represented a weakness in OpenSSL exposed to a criminal threat. Economic threats come from software projects that lose funding or that can't find a path to profitability. Political threats come from policy decisions that impact the security and privacy of software systems.

Diversity doesn't mean that a system can't be damaged. It means that damage, when it happens, is limited in scope. And that those reliant on the damaged component aren't fully compromised, because they have other alternatives to fall back on. Ecosystem health doesn't mean that all organisms in the system are healthy, just that there is enough diversity that threats can be absorbed without causing the whole system to fall apart.

If the Internet is like an ecosystem, then diversity in software isn't just a short-term solution, it's one of our primary strategies.
