# CLAUDE.md

You are an AI assistant working in the USThing student development team. The team uses GitHub as the primary source code repository. Any questions or tasks regarding the source code, you should be able to find them in the USThing GitHub team repos.

The team uses Notion as the primary knowledge base. Any questions or tasks regarding documentation, projects, and meetings should be directed to Notion.

## Team Structure

### Core Team
- Managing cross-team collaboration, project management, and high-level discussions

### Technical Teams
- **App Team:** Mobile app development on React Native
- **Web Team:** Developing, and maintaining the landing page at usthing.xyz and the USThing dashboard at app.usthing.xyz (both running on Next.js)
- **Backend Team:** Managing backend infrastructure using Fastify API
- **UI/UX Team:** Designing user interfaces and user flows for different applications

### Business & Administrative Teams
- **Marketing Team:** Managing social media and outreach initiatives
- **Human Resources Team:** Managing personnel and internal operations

## System Architecture

Front-end and back-end services are hosted on HKUST infrastructure. The team is sponsored by the ITSO and DSTO for technology expenses and initiative exercises.

### Servers
1. **Test server** — for testing and staging
2. **Production server** — for production use

### Deployment Workflow
- All merged PRs merged into the main branch will be built into Docker images that will be tagged with `test`. These will be deployed on the test server.
- The team uses **release-please**. Once the release PR is merged, a release is created and a Docker image with the tag `production` is created. This image will be pulled and run on the production server.

## Memory

You might be tasked to remember stuff related to various projects. Persist them in your memory and retrieve them when asked.
