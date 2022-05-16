import React from 'react';
import clsx from 'clsx';
import styles from './styles.module.css';

const FeatureList = [
  {
    title: 'Native look and feel',
    Svg: require('@site/static/img/undraw_flutter_dev.svg').default,
    description: (
      <>
        Create beautiful Flutter applications for macOS that match the look and feel of native Cocoa/AppKit.
      </>
    ),
  },
  {
    title: 'Great Developer Experience',
    Svg: require('@site/static/img/undraw-programming.svg').default,
    description: (
      <>
        macos_ui provides API's that are easy to understand, with tons of customization options and detailed documentation.
      </>
    ),
  },
];

function Feature({Svg, title, description}) {
  return (
    <div className={clsx('col col--6')}>
      <div className="text--center">
        <Svg className={styles.featureSvg} role="img" />
      </div>
      <div className="text--center padding-horiz--md">
        <h3>{title}</h3>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures() {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
