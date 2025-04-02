import React from 'react'
import Head from 'next/head'
import Header from '../src/components/Header'
import styles from '../src/styles/Browse.module.css'

const Browse: React.FC = () => {
  const mockTracks = [
    {
      id: 1,
      title: "Digital Dreams",
      artist: "CryptoBeats",
      genre: "Electronic",
      price: "0.1 ETH",
      duration: "3:45",
      image: "/placeholder-album.jpg"
    },
    {
      id: 2,
      title: "Blockchain Blues",
      artist: "NFTunes",
      genre: "Blues",
      price: "0.05 ETH",
      duration: "4:20",
      image: "/placeholder-album.jpg"
    },
    {
      id: 3,
      title: "Mint My Soul",
      artist: "TokenTunes",
      genre: "Hip Hop",
      price: "0.2 ETH",
      duration: "2:58",
      image: "/placeholder-album.jpg"
    }
  ]

  return (
    <div className={styles.container}>
      <Head>
        <title>Browse Music - MelodyChain</title>
        <meta name="description" content="Browse and discover music NFTs" />
      </Head>

      <Header />

      <main className={styles.main}>
        <div className={styles.content}>
          <h1 className={styles.title}>Browse Music NFTs</h1>

          <div className={styles.filters}>
            <select className={styles.select}>
              <option>All Genres</option>
              <option>Electronic</option>
              <option>Hip Hop</option>
              <option>Rock</option>
              <option>Jazz</option>
              <option>Blues</option>
            </select>

            <select className={styles.select}>
              <option>Price: Low to High</option>
              <option>Price: High to Low</option>
              <option>Recently Added</option>
              <option>Most Popular</option>
            </select>
          </div>

          <div className={styles.grid}>
            {mockTracks.map(track => (
              <div key={track.id} className={styles.card}>
                <div className={styles.imageContainer}>
                  <div className={styles.placeholderImage}>🎵</div>
                  <div className={styles.playOverlay}>▶</div>
                </div>

                <div className={styles.info}>
                  <h3 className={styles.trackTitle}>{track.title}</h3>
                  <p className={styles.artist}>{track.artist}</p>
                  <p className={styles.genre}>{track.genre} • {track.duration}</p>

                  <div className={styles.priceSection}>
                    <span className={styles.price}>{track.price}</span>
                    <button className={styles.buyButton}>Buy Now</button>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </main>
    </div>
  )
}

export default Browse