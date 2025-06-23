# ITE-SPA-06: Integration and Deployment

**Havit C. Rovik** | Universitas ‘Aisyiyah Yogyakarta (UNISA) | 24.06.2025

> “Bridging classic enterprise concepts with modern cloud-native practices”

## 6.1.4 Tags for IT Domains

All IT domains contain identifying tags. These tags always contain the prefix “IT_” to distinguish them from other related computing curricula reports.

We use
*   “ITE” for essential IT domains,
*   “ITS” for supplemental IT domains,
*   and “ITM” for related IT mathematics.

Each IT domain has a three-letter abbreviation such as `IOT` for representing internet of things or `NET` for representing networks. As a result, each domain contains two parts separated by a hyphen.

For example, we use `ITE-UXD` to represent “user experience design” as an essential IT domain, `ITS-VSS` for representing “virtual systems and services” as a supplemental IT domain, and `ITM-DSC` for representing “discrete structures” as a mathematical domain related to information technology.

The subdomains of each IT domains are numbered. For example, the first two subdomains in `ITE-UXD` are `ITE-UXD-01` and `ITE-UED-02`.

Ref: Information Technology Curricula 2017 (IT2017) Curriculum Guidelines for Baccalaureate Degree Programs in Information Technology

## Today's Agenda

### ITE-SPA-06 Agenda

*   Introduction: Why Modern Integration Matters
*   Middleware Platforms in AWS
*   Choosing the Right Integration Platform
*   Wrappers vs Glue Code Integration
*   Frameworks for Integration
*   Enterprise Data Warehouse & AWS
*   Testing & Evaluation in Cloud Integrations
*   A Glimpse of Deployment
*   Summary

## About Havit C. Rovik

### Introduction

*   Facilitator at “AI-Volution: Machine Learning for Social Impact” (2025)
*   Spoke at “The State of AI in Fintech and the Digital Economy” (2025)
*   Graduate of the Amplifier Program by 10x1000 Tech for Inclusion (2024)
*   Grand Finalist at Mitrais Innovathon (2021)
*   Spoke at “Founder Session: React Native to Handle 3 Platforms” (2020)
*   Mentor at DILo Developer Class Season 7 “React Native” (2019)
*   Author at Level Up Coding (2019)
*   Participant at Hacktoberfest (2018 - 2023)
*   Contributor at React Native Elements (2018 - 2022)

**Senior Software Engineer @OSOME**

*   1st Winner BRI x Tech in Asia FutureMakers (2024)
*   1st Winner OCBC NISP Hack@ON (2022)
*   1st Winner BCA Finhacks #Codescape (2017)

## Why Talk About Integration & Amazon Web Service (AWS)?

### Why Modern Integration Matters

Before we dive into the technical mappings, let’s first understand why integration is such a critical topic. And why AWS is at the center of that conversation today.

#### Enterprises Rely on Distributed Systems

In today’s tech landscape, no enterprise system exists in isolation. Applications are built with microservices, SaaS platforms, legacy components, and third-party integrations. These components are distributed across locations, teams, cloud providers, and data centers.

Even a simple user registration process might involve 3-4 different services: frontend app, authentication API, email system, and a data store. All of them must be integrated seamlessly.

#### Middleware and Integration are Key to System Interoperability

Middleware acts as the “glue” that connects these distributed components. It enables interoperability, message passing, data transformation, and workflow orchestration.

Classical examples: ESBs (Enterprise Service Buses), message queues, RPC, etc.

Without middleware, every system must speak the same language, which is neither practical nor scalable.

#### Timeless Concepts

This session maps classical learning (`ITE-SPA-06`) to real AWS solutions. `ITE-SPA-06` teaches timeless concepts: middleware types, wrapper and glue code integration, data warehousing, and testing impacts.

#### Today's Goal

> “Translate those classroom concepts into modern, AWS-native implementations”

By the end of this session, we’ll be able to take each concept from the syllabus and say: “Here’s how we’d do that in AWS today.” That’s the value we want to deliver.

> “So integration isn’t just a tech buzzword. It’s the foundation of how modern systems stay connected and responsive. Let’s now explore how middleware platforms are handled in the AWS ecosystem.”

## Middleware Platforms in AWS

This slide maps traditional middleware concepts to their modern AWS counterparts. These are the backbone for service communication in cloud-native environments.

### What is Middleware?

📘 What is it?
Middleware is software that acts as a bridge between different applications, services, or systems.

> “It is helping them communicate, exchange data, and work together effectively.”

### Middleware in AWS = Integration Layer

It enables:
*   Service-to-service communication
*   Legacy system integration
*   Secure API exposure
*   Event-driven orchestration
*   Data transformation & routing

### AWS Offers API & Event-driven Tools as Modern Middleware

AWS has redefined middleware through managed services:
*   **API Gateway** for synchronous REST/HTTP-based communication
*   **SNS/SQS** for asynchronous event-based communication
*   **Lambda** for orchestration and observability

These tools provide cloud-native, serverless, auto-scaling, and resilient ways to handle integration.

> “So, instead of building middleware from scratch, we now compose integrations using AWS primitives.”

### What is an API?

📘 What is an API?
API stands for Application Programming Interface.

> “It is a set of rules and definitions that allows software applications to communicate with each other.”

[https://aws.amazon.com/what-is/api/](https://aws.amazon.com/what-is/api/)

There are four different ways that APIs can work depending on when and why they were created.

#### Types of APIs

*   **SOAP APIs**
    These APIs use Simple Object Access Protocol. Client and server exchange messages using XML. This is a less flexible API that was more popular in the past.
*   **RPC APIs**
    These APIs are called Remote Procedure Calls. The client completes a function (or procedure) on the server, and the server sends the output back to the client.
*   **Websocket APIs**
    Websocket API is another modern web API development that uses JSON objects to pass data. A WebSocket API supports two-way communication between client apps and the server. The server can send callback messages to connected clients, making it more efficient than REST API.
*   **REST APIs**
    These are the most popular and flexible APIs found on the web today. The client sends requests to the server as data. The server uses this client input to start internal functions and returns output data back to the client. Let’s look at REST APIs in more detail below.

#### APIs in AWS Middleware

In the context of AWS and middleware, APIs are used to:
*   Expose backend services (e.g., via Amazon API Gateway)
*   Enable integration between microservices
*   Allow external systems (like web/mobile apps) to access our cloud-based logic and data

Example in AWS Middleware:
Amazon API Gateway acts as a "front door" for REST or WebSocket APIs. It integrates with services like Lambda, Step Functions, or ECS, turning them into accessible APIs.

So when we say "API & Event-driven tools as modern middleware," it means AWS provides tools to:
*   Expose services via APIs (API Gateway, AppSync)
*   React to events in real time (EventBridge, SNS, SQS)

Both approaches allow loose coupling, scalability, and faster integration across distributed systems.

### What is Event-Driven Architecture?

🔄 What is Event-Driven Architecture?
Event-driven architecture (EDA) is a design paradigm where services communicate by producing and consuming events, rather than through direct API calls.

In this model:
*   Services emit events (e.g., “OrderCreated”, “UserRegistered”) when something happens.
*   Other services listen to and react to these events asynchronously.

This decouples systems and enables more flexible, scalable, and loosely coupled integrations.

#### AWS Event-Driven Middleware Tools

*   **Simple Notification Service (SNS)**
    *   Pub/Sub messaging for fan-out event delivery
    *   Good for broadcasting events to multiple consumers
*   **Simple Queue Service (SQS)**
    *   Message queue for decoupling producers and consumers
    *   Ensures reliable delivery and retries

#### UserSignedUp Event Flow Example

A user signs up:
*   app publishes a `UserSignedUp` event
*   Several services react:
    *   a Lambda function sends a welcome email
    *   another Lambda function creates a profile in the CRM
    *   an analytics service logs the event for BI

#### CRM — Customer Relationship Management

📇 CRM — Customer Relationship Management
A CRM system helps businesses manage interactions with current and potential customers.

Common CRM tasks include:
*   Tracking leads and sales
*   Managing customer data
*   Automating marketing or customer service workflows

Examples: Salesforce, HubSpot, Zoho CRM

#### BI — Business Intelligence

📊 BI — Business Intelligence
BI tools are used to analyze data and help organizations make informed business decisions.

They transform raw data into dashboards, reports, and visual insights.

Common BI activities:
*   Tracking KPIs
*   Identifying trends
*   Generating executive summaries

Examples: Power BI, Tableau, Looker

### Demo

Demo 🪧
AWS Dashboard.
AWS API Gateway, SNS, SQS and Lambda.

### Key AWS Middleware Services

*   **API Gateway**
    > “It replaces the traditional API middleware layer. It’s the front door to our services: secured, scaled, and managed.”
*   **SNS**
    > “Simple Notification Service is useful when one event needs to notify multiple systems at once.”
*   **SQS**
    > “Simple Queue Service helps absorb traffic spikes and ensures that even if a backend service fails, no data is lost.”

By the end of this session, we’ll be able to take each concept from the syllabus and say: “Here’s how we’d do that in AWS today.” That’s the value we want to deliver.

> “So, whether we’re integrating components synchronously via REST or asynchronously via events and queues, AWS provides specialized middleware services for each. In the next slide, we’ll compare their trade-offs and help we choose the right one for our use case.”

## Comparing Middleware Platforms

📘 Mapping to ITE-SPA-06: Demonstrate the advantages and disadvantages of some middleware platforms

Now that we’ve seen the available middleware services in AWS, let’s compare their strengths and weaknesses. This helps us choose the right one based on our integration scenario.

### API Gateway

✅ Works well for synchronous REST requests
✅ Offers rate limiting, API keys, CORS, caching
❌ Not ideal for background or long-running tasks

> “Use this when clients need immediate feedback. Like a web or mobile app calling a backend service.”

*   **🌐 REST (Representational State Transfer)**
    REST is an architectural style for designing APIs over HTTP.
    Each resource (e.g., `/users`, `/orders`) is accessed using standard HTTP methods: `GET`, `POST`, `PUT`, `DELETE`, etc.
    REST is stateless and well-suited for real-time, request-response interactions (like retrieving user data or submitting a form).
    Good for: frontends calling backends, mobile apps, microservices communication.
*   **📉 Rate Limiting**
    Controls how many requests a client can make in a given time window.
    Protects backend systems from abuse, DDoS attacks, or accidental overload.
    Example: "100 requests per minute per API key"
    Common in API Gateways (e.g., AWS API Gateway)
*   **🔐 API Keys**
    Simple way to authenticate and track usage.
    Each client gets a unique API key, which must be included in each request.
    Helps:
    *   Identify usage patterns
    *   Enforce rate limits
    *   Enable/disable access easily
*   **🌍 CORS (Cross-Origin Resource Sharing)**
    A browser-side security feature that restricts JS apps from making requests to a different domain.
    If your API is called from a frontend hosted on another domain (e.g., `yourfrontend.com` → `api.yourbackend.com`), CORS must be enabled.
    APIs need to explicitly allow origins, methods, and headers via CORS settings.
*   **⚡ Caching**
    Saves previous responses to speed up future identical requests.
    Reduces backend load and latency.
    Can be done at multiple levels:
    *   Client-side (browser)
    *   Edge/CDN (e.g., CloudFront)
    *   API Gateway or reverse proxy
    Example: cache `GET` requests to `/products`

### Simple Notification Service (SNS)

✅ Great for real-time, broadcast-like scenarios
✅ Simple to integrate with Lambda, HTTP, SQS
❌ Limited filtering, cannot store messages

> “SNS is excellent for sending alerts or events to multiple systems, but it's not suitable if we need durable message storage.”

*   **❌ Limited Filtering**
    SNS does support basic message filtering, but:
    *   It’s rule-based, not content-indexed
    *   We must set filters per subscription, not at topic level
    Complex routing or content-based filtering? Use Amazon EventBridge instead.
*   **❌ Cannot Store Messages (No Persistence)**
    SNS is a fire-and-forget system:
    *   Once a message is published, it’s immediately pushed to subscribers.
    *   No message retention. If a subscriber is down or unresponsive, the message is lost.
    Contrast this with SQS, which stores messages until they’re consumed or expire.

### Simple Queue Service (SQS)

✅ Designed for reliability and decoupling
✅ FIFO and DLQ support add robustness
❌ Requires polling, and there’s no real-time push

> “SQS is our go-to for background jobs or when a consumer needs to process messages at its own pace.”

*   **✅ Designed for Reliability and Decoupling**
    **🧩 Message Queue Pattern**
    SQS decouples producers and consumers:
    *   Producers send messages to a queue.
    *   Consumers fetch and process messages when ready.
    They don't need to know about each other’s existence, scale, or state.
    **✅ Key Benefits:**
    *   Fault-tolerance: If a consumer fails, the message stays in the queue until it's successfully processed or expires.
    *   Scalability: Consumers can scale up/down independently from producers.
    *   Loose coupling improves modularity, simplifies testing, and isolates failures.
*   **✅ FIFO and DLQ Support Add Robustness**
    **🔄 FIFO (First-In, First-Out)**
    Ensures exact ordering of messages and no duplicates.
    Important for systems like:
    *   Financial transactions
    *   Order processing
    *   Step-by-step workflows
    **💥 DLQ (Dead-Letter Queue)**
    Captures messages that fail repeatedly to be processed.
    Prevents “bad messages” from blocking the rest of the queue.
    Helps with debugging and improving system resilience.

> “There’s no one-size-fits-all middleware. Our choice depends on factors like latency tolerance, reliability, fan-out needs, and system coupling. Let’s now look at how we choose the right platform for our enterprise.”

## Selection Considerations

📘 Mapping to ITE-SPA-06: Justify major considerations for the selection of an enterprise integration platform

When selecting an integration platform, especially in enterprise or cloud-native environments, there are several key factors to consider. AWS gives us multiple tools, but using the right one in the right context is critical.

### Scalability

*   SNS auto-scale without pre-provisioning
*   SQS also scales, but consumer scaling may be manual (unless paired with Lambda)

> “For unpredictable spikes in demand, event-based services like SNS shine.”

SNS scale automatically to handle spikes.

### Latency Requirements

*   API Gateway provides low-latency REST responses
*   SQS introduce some delay due to async nature

> “When the user needs an immediate response, stick with APIs.”

API Gateway is best for low-latency needs.

### Coupling Strategy

*   **Tightly coupled**
    *   API Gateway ties services directly together
*   **Loosely coupled**
    *   Events via SNS don’t require upstream-downstream awareness
    *   Tight coupling → API Gateway
    *   Loose coupling → SNS, SQS, EventBridge

> “The more decoupled our architecture, the more resilient and flexible it becomes.”

### Resilience & Reliability

*   Use SQS with DLQ (Dead Letter Queue) to avoid message loss
*   Ensure idempotency in Lambda functions to handle retries gracefully
*   SQS + DLQ for failure handling
*   Idempotent Lambda functions for retries

> “Failures will happen. What matters is how gracefully our system recovers.”

### Cost & Complexity

*   API Gateway is cost-efficient for low-volume APIs
*   SNS + SQS can become complex and costly if overused
*   Simple API? Use API Gateway

> “Start simple. Only add complexity when we really need the flexibility.”

> “These are the same criteria used in enterprise architecture, only now they’re applied using cloud-native AWS services. Next, we’ll look at how integration can be done using the wrapper approach.”

## Integration Using the “Wrapper” Approach

📘 Mapping to ITE-SPA-06: Express different ways of integration using the “wrapper” approach

The wrapper approach is one of the most practical methods of integrating legacy systems with modern platforms, especially in cloud migrations.

### What is a Wrapper?

📘 What is a Wrapper?
A wrapper is a thin interface placed around a legacy system or incompatible module.

> “It doesn’t change the underlying system but translates requests/responses.”

Think of it like a translator between an old system and the modern world.
The modern app sends a request in its own format (e.g., JSON over HTTP)
The wrapper receives it, translates it into the format expected by the legacy system (e.g., SOAP, XML, file-based protocol)
The legacy system processes it and returns a response
The wrapper then translates the response back for the modern app

### Example Scenarios

🧱 Example Scenarios
Legacy HR system that only accepts CSV via FTP
→ Wrapper exposes an HTTP REST API, and behind the scenes, converts incoming JSON to CSV and uploads via FTP.

### Common Wrapper Use Cases in AWS

*   **API Gateway + Lambda as a Wrapper**
    *   Wraps any backend, old or new, as a RESTful API
    *   Secure, scalable, and easy to expose to clients
*   **Transform SOAP/XML into REST/JSON**
    *   Use Lambda functions to convert XML input/output into modern JSON APIs
    *   Useful when integrating old ERP, CRM, or banking systems

This helps when you need to modernize interfaces without rewriting backend code.

### Benefits of the Wrapper Approach

*   **Non-invasive**
    *   No need to rewrite legacy code
*   **Compatibility**
    *   Makes old systems cloud- or API-compatible
*   **Flexibility**
    *   Acts as a stepping stone to full modernization

It’s a low-risk, high-reward strategy. Especially when working with critical, hard-to-change systems.

> “By using the wrapper approach on AWS, we bring legacy systems into modern cloud architectures. Paving the way for gradual digital transformation. Next, we’ll explore the glue code approach, which complements this strategy in different scenarios.”

## Integration Using the “Glue Code” Approach

📘 Mapping to ITE-SPA-06: Express different ways of integration using the “Glue Code” approach

Where wrappers provide a general interface around a system, glue code dives deeper, writing custom code to bind specific components together. This is especially useful when standard tools aren’t enough.

### What is Glue Code?

📘 What is Glue Code?
It is custom scripting or programming that connects different services, formats, or APIs.

> “It often handles transformations, coordination, or data reshaping.”

We use glue code when off-the-shelf tools can’t meet a specific business or technical requirement.

As well as the new service and the legacy monolith, there are two other components. The first is a request router, which handles incoming (HTTP) requests. It is similar to the API gateway. The router sends requests corresponding to new functionality to the new service. It routes legacy requests to the monolith.

The other component is the glue code, which integrates the service with the monolith. A service rarely exists in isolation and often needs to access data owned by the monolith. The glue code, which resides in either the monolith, the service, or both, is responsible for the data integration. The service uses the glue code to read and write data owned by the monolith.

The glue code is sometimes called an anti‑corruption layer. That is because the glue code prevents the service, which has its own pristine domain model, from being polluted by concepts from the legacy monolith’s domain model. The glue code translates between the two different models. The term anti‑corruption layer first appeared in the must‑read book Domain Driven Design by Eric Evans and was then refined in a white paper. Developing an anti‑corruption layer can be a non‑trivial undertaking. But it is essential to create one if you want to grow your way out of monolithic hell.

Ref: [https://www.f5.com/company/blog/nginx/refactoring-a-monolith-into-microservices](https://www.f5.com/company/blog/nginx/refactoring-a-monolith-into-microservices)

### Example of Glue Code in AWS

*   **Lambda as Transformers or Brokers**
    *   E.g., receive an event, transform it, and call an external API
    *   Translate between systems with different data formats or contracts

This helps when you need to modernize interfaces without rewriting backend code.

### Benefits of the Glue Code

*   **Tailored** to exact needs
*   **Enables integration** where no standard option fits
*   **Useful** for migrating complex business logic

### Cons of Glue Code

⚠️ Cons:
*   Increases maintenance burden
*   Risk of hard coded logic or duplication
*   Can grow into “hidden monoliths” if unmanaged

> “The more glue we write, the more careful we must be about documentation, testing, and ownership.”

### Demo

Demo 🪧
Semboja-monorepos.
An API-Based and Event-Driven integrations.

Demo 🪧
Semboja SymbaPay.
A payment management system.

> “Glue code is powerful, but should be used wisely. In AWS, serverless tools make glue code easier to manage and scale, but architectural discipline is key. Next, we’ll see how frameworks help reduce the amount of glue we need.”

## Frameworks that Support Integration

📘 Mapping to ITE-SPA-06: Describe how a framework facilitates integration of components

Frameworks provide scaffolding that simplifies how we build, integrate, and maintain applications. In AWS, several frameworks make integration tasks easier, especially for serverless and event-driven systems.

### What is a Framework?

📘 What is a Framework?
A framework gives developers a structured environment for building applications.

> “It often comes with tools, libraries, and patterns for managing complexity.”

Think of a framework as a recipe kit. It helps us cook the right way every time, faster and with fewer mistakes.

### Popular Frameworks for AWS Integration

*   **Serverless Framework**
    *   Deploy APIs and event-driven apps to AWS Lambda easily
    *   Abstracts away infrastructure details for multicloud serverless apps
    *   Supports plugins and easy deployments
    > “Great for teams who want speed, simplicity, and don’t need to learn full AWS deployment syntax.”
*   **NestJS**
    *   Building efficient, reliable and scalable server-side applications
    *   Helps build well-structured REST APIs
    *   Supports dependency injection, middleware, and modularization
    > “NestJS is especially great when building backend services that integrate with other AWS components.”

### Case Study: Banking Integrations (Semboja)

💡Case Study: Banking Integrations
How Semboja leveraged an integration framework, deployed on AWS infrastructure, to win 1st place in a hackathon.

#### OCBC Chat Assistant Features

Five features by Semboja OCHA (OCBC Chat Assistant)
*   💡Onboarding
*   💡Transfer
*   💡Payment
*   💡Check Balance & Transaction History

#### OCHA Infrastructure

#### Under the Hood

### Benefits of Using Frameworks

*   **Less Glue Code**
    *   Reusable patterns reduce the need for custom integrations
*   **Best Practices Built-In**
    *   Security, error handling, and retries are often pre-configured
*   **Scalability & Maintenance**
    *   Easier to onboard new developers and scale teams

Frameworks reduce tribal knowledge and increase software hygiene.

> “Frameworks allow us to focus on business logic rather than wiring components manually. Next, we’ll shift gears and look at how data integration, specifically the data warehouse, fits into enterprise integration.”

## Data Warehousing in Enterprise Integration

📘 Mapping to ITE-SPA-06: Describe how the data warehouse concept relates to enterprise information integration

While APIs and events help us integrate operational systems in real-time, the data warehouse plays a key role in long-term data integration, analysis, and business insight.

### What is a Data Warehouse?

📘 What is a Data Warehouse?
Centralized repository for structured, historical business data from multiple sources.
Optimized for OLAP (Online Analytical Processing), not for transactions.

> “This is where we go to get the big picture: long-term trends, patterns, and reports.”

Centralized repository for structured, historical business data.
While APIs and events help us integrate operational systems in real-time, the data warehouse plays a key role in long-term data integration, analysis, and business insight.

### Role in Integration

*   Aggregates data from multiple operational systems
*   Supports analytics, reporting, and Business Intelligence
*   Enables a “single source of truth”

Business intelligence (BI) is the process of using the power of people and technologies to collect and analyze data to be used by organizations in their strategic and daily decision-making processes.

Ref: [https://cloud.google.com/learn/what-is-business-intelligence](https://cloud.google.com/learn/what-is-business-intelligence)

### Business Intelligence (BI)

How do companies use business intelligence?

Companies across industries use business intelligence for the following:
*   **Reporting**
    *   Providing regular summary data to key decision-makers to support their ability to set business strategy and direction.
*   **Data visualization**
    *   Presenting information visually in a way that aids the rapid understanding of complex information.
*   **Predictive analytics**
    *   Analyzing historical data to predict future patterns using statistical techniques like data mining, machine learning, and predictive modeling.
*   **Data mining**
    *   Searching through large datasets to find useful patterns or trends.
*   **Complex event processing**
    *   Analyzing streaming, real-time data from sources such as stock-market feeds, traffic reports, or electrical grids with sensors.
*   **Business performance management**
    *   Analyzing and measuring performance goals, such as operational excellence goals defined by online shopping and customer satisfaction.

### Amazon Redshift

> “Powers modern data analytics at scale”

Source:
[https://youtu.be/c77Kz3eBH7M?si=ik9Gviau1qmY6uZi](https://youtu.be/c77Kz3eBH7M?si=ik9Gviau1qmY6uZi)
[https://aws.amazon.com/redshift/](https://aws.amazon.com/redshift/)

> “Data warehouses are essential to enterprise information integration. They unify scattered data into a coherent, reliable foundation for decision-making. Finally, let’s examine how integration choices affect testing and evaluation.”

## Testing & Evaluation Impact

📘 Mapping to ITE-SPA-06: Describe how integration choices affect testing and evaluation

Our integration architecture directly influences how we test and evaluate our systems. Real-time APIs and async events require different approaches, and AWS provides tools for both.

### What is it?

🧪 What is it?
Testing & Evaluation Impact refers to the influence that a system’s integration approach, architecture, or changes have on the way it must be tested and validated.

Centralized repository for structured, historical business data.
While APIs and events help us integrate operational systems in real-time, the data warehouse plays a key role in long-term data integration, analysis, and business insight.

### How Integration Type Affects Testing

*   **Event-Driven Integration**
    *   Requires testing full event flow, often with real components
    *   Harder to simulate timing and order issues
    *   Test side effects, not just return values
    > “We test not what comes back, but what happens as a result.”
*   **API-based Integration**
    *   Easier to unit test and mock using tools like Postman, Jest, or Supertest
    *   Response-based → simple assertion-driven tests
    > “We can simulate most things with mocks or local testing.”

### Postman

> “Execute, test, and interact with APIs in seconds”

Source:
[https://www.postman.com/](https://www.postman.com/)

### Evaluation Impact

*   **Latency and Performance**
    *   Measure end-to-end time across services
    *   Use CloudWatch or X-Ray metrics
*   **Data Integrity**
    *   Ensure no data loss or duplication across retries/events
*   **Failure Handling**
    *   Test retry strategies, dead-letter queues, and fallback logic
    *   Use chaos testing in non-prod
*   **Observability**
    *   Ensure logs, traces, and metrics are unified and queryable
    > “What we can’t observe, we can’t trust.”

> “Good integration is invisible to the user, but that only happens when testing is visible to the developer. With the right architecture and tooling, we can makes this level of visibility achievable.”

## Deployment

### What is Deployment?

🚀 What is Deployment?
A process of releasing and running an application or system in a live environment, making it available for users or systems to access and use.

> “It is taking our application from development and putting it into production.”

### Typical Deployment Process

🛠️ Key Steps in a Typical Deployment Process:
*   **Build** — Compile code, bundle dependencies, and prepare assets
*   **Test** — Run unit, integration, and acceptance tests
*   **Package** — Create deployable artifacts (e.g., containers, ZIP files)
*   **Deploy** — Upload or distribute the application to servers/cloud
*   **Release** — Make the application accessible to users or systems
*   **Monitor** — Track performance, logs, and errors post-deployment

### Deploying to AWS (Serverless)

> “Deploying to AWS”

Source:
[https://www.postman.com/](https://www.postman.com/)

> “Deployment in the cloud has evolved. With serverless architecture and AWS services, we can now deploy faster, scale effortlessly, and focus more on building value rather than managing infrastructure.”

## What We've Learned Today

### ITE-SPA-06: Integration and Deployment

*   Express different ways for middleware platforms.
*   Justify major considerations for the selection of an enterprise integration platform.
*   Express different ways of integration using the "glue code" approach.
*   Describe how the data warehouse concept relates to enterprise information integration.
*   Demonstrate the advantages and disadvantages of some middleware platforms.
*   Express different ways of integration using the "wrapper" approach.
*   Describe how a framework facilitates integration of components.
*   Describe how integration choices affect testing and evaluation.

[linkedin.com/in/havit](https://linkedin.com/in/havit)