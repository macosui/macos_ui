import React from 'react';
import clsx from 'clsx';
import Layout from '@theme/Layout';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import styles from './index.module.css';
import HomepageFeatures from '@site/src/components/HomepageFeatures';
import Translate, { translate } from "@docusaurus/Translate";
import GitHubButton from "react-github-btn";
import { Follow } from "react-twitter-widgets";

function HomepageHeader() {
  const { siteConfig } = useDocusaurusContext();
  return (
    <header className={clsx('hero hero--dark', styles.heroBanner)}>
      <div className="container">
        <h1 className="hero__title">{siteConfig.title}</h1>
        <p className="hero__subtitle">
          <Translate id="home.tagline">
            {siteConfig.tagline}
          </Translate>
        </p>
        <div className={styles.buttons}>
          <Link to="https://pub.dev/packages/macos_ui">
            <img src="https://img.shields.io/pub/v/macos_ui.svg" />
          </Link>
          <Spacer />
          <Link to="https://pub.dev/packages/macos_ui">
            <img src="https://badges.bar/macos_ui/likes" />
          </Link>
          <Spacer />
          <Link to="https://pub.dev/packages/macos_ui/score">
            <img src="https://img.shields.io/pub/points/macos_ui?color=blue" />
          </Link>
        </div>
        <Spacer />
        <Spacer />
        <div className={styles.buttons}>
          <GitHubStarButton />
          <Spacer />
          <Link to="https://github.com/sponsors/GroovinChip">
            <img src='https://img.shields.io/github/sponsors/GroovinChip?color=white' />
          </Link>
          <Spacer />
          <TwitterButton />
        </div>
        <Spacer />
        <Spacer />
        <div className={styles.buttons}>
          <Link
            className="button button--primary button--lg"
            to="/docs/getting_started/overview"
          >
            <Translate id="home.get_started">Get Started</Translate>
          </Link>
        </div>
      </div>
    </header>
  );
}

function Spacer() {
  return <div style={{ width: "10px", height: "10px" }}></div>;
}

function TwitterButton() {
  return (
    <Follow
      username="GroovinChip"
      options={{
        dnt: true,
        size: "small",
        showCount: false,
        showScreenName: false,
        lang: translate({
          id: "home.twitter_locale",
          message: "en",
        }),
      }}
    />
  );
}

function GitHubStarButton() {
  return (
    <div className="github-button">
      <GitHubButton
        href="https://github.com/GroovinChip/macos_ui"
        data-show-count="true"
        // data-size="large"
        aria-label="Star GroovinChip/macos_ui on GitHub"
      >
        Star
      </GitHubButton>
    </div>
  );
}

export default function Home() {
  const { siteConfig } = useDocusaurusContext();
  return (
    <Layout
      title={siteConfig.title}
      description={`${siteConfig.tagline}`}>
      <HomepageHeader />
      <main>
        <HomepageFeatures />
      </main>
    </Layout>
  );
}