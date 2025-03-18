import Head from 'next/head'
import styles from '../src/styles/Home.module.css'

export default function Home() {
  return (
    <div className={styles.container}>
      <Head>
        <title>MelodyChain - Music NFT Marketplace</title>
        <meta name="description" content="Blockchain-based music NFT marketplace" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        <h1 className={styles.title}>
          Welcome to <span className={styles.highlight}>MelodyChain</span>
        </h1>

        <p className={styles.description}>
          A decentralized marketplace for music NFTs
        </p>

        <div className={styles.grid}>
          <div className={styles.card}>
            <h3>Upload Music</h3>
            <p>Mint your musical creations as NFTs</p>
          </div>

          <div className={styles.card}>
            <h3>Browse Collection</h3>
            <p>Discover unique music from artists worldwide</p>
          </div>

          <div className={styles.card}>
            <h3>Marketplace</h3>
            <p>Buy and sell music NFTs with crypto</p>
          </div>

          <div className={styles.card}>
            <h3>Earn Royalties</h3>
            <p>Artists earn from every resale</p>
          </div>
        </div>
      </main>
    </div>
  )
}