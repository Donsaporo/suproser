import React, { useState } from 'react';
import { Play, Clock } from 'lucide-react';
import { videos } from '../data/dummy';

export default function Videos() {
  const [selectedVideo, setSelectedVideo] = useState<string | null>(null);

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <div className="text-center mb-12">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">Videos Educativos</h1>
        <p className="text-lg text-gray-600 max-w-2xl mx-auto">
          Aprende las mejores técnicas de limpieza profesional con nuestros videos instructivos.
        </p>
      </div>

      {/* Featured Video */}
      {selectedVideo && (
        <div className="mb-12 bg-white rounded-xl shadow-lg overflow-hidden">
          <div className="aspect-video">
            <iframe
              src={selectedVideo}
              title="Video featured"
              className="w-full h-full"
              frameBorder="0"
              allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
              allowFullScreen
            />
          </div>
        </div>
      )}

      {/* Video Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        {videos.map((video) => (
          <div
            key={video.id}
            className="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-all duration-300 cursor-pointer group"
            onClick={() => setSelectedVideo(video.url)}
          >
            <div className="aspect-video relative overflow-hidden">
              <img
                src={video.thumbnail}
                alt={video.title}
                className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                loading="lazy"
              />
              <div className="absolute inset-0 bg-black bg-opacity-30 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                <div className="bg-white bg-opacity-90 rounded-full p-3">
                  <Play className="h-6 w-6 text-blue-600" />
                </div>
              </div>
            </div>
            
            <div className="p-4">
              <h3 className="font-semibold text-gray-900 mb-2 group-hover:text-blue-600 transition-colors duration-200">
                {video.title}
              </h3>
              <p className="text-sm text-gray-600 mb-3 line-clamp-2">
                {video.description}
              </p>
              <div className="flex items-center text-xs text-gray-500">
                <Clock className="h-3 w-3 mr-1" />
                <span>5:30</span>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}