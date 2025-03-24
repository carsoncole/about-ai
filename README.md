# About-AI

This Ruby on Rails application is a personal website that provides an AI agent for answering any questions about you.



## Requirements

### AnythingLLM

This application uses AnythingLLM as the agent, which will maintain context and forward prompts to the LLM. For simplicity, I run Anything LLM on a self-hosted Mac Mini Pro. Very simple to set up. The AnythingLLM configuration will handle the connection with whatever LLM you will be using.

### LLM

You will need API access to an LLM that will provide responses back to the application. In my case, I'm running my own LLM with LM Studio, also on a Mac Mini Pro.

### Ruby version

3.4.2

### Rails version

8.0.1
