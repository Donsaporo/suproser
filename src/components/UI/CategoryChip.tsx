import React from 'react';
import { Link } from 'react-router-dom';

interface CategoryChipProps {
  name: string;
  slug: string;
  icon?: React.ReactNode;
}

export default function CategoryChip({ name, slug, icon }: CategoryChipProps) {
  return (
    <Link
      to={`/productos?categoria=${slug}`}
      className="flex items-center space-x-2 bg-white px-6 py-4 rounded-lg shadow-md hover:shadow-lg transition-all duration-300 hover:-translate-y-1 group"
    >
      {icon && (
        <div className="text-blue-600 group-hover:text-blue-700 transition-colors duration-200">
          {icon}
        </div>
      )}
      <span className="font-medium text-gray-900 group-hover:text-blue-600 transition-colors duration-200">
        {name}
      </span>
    </Link>
  );
}